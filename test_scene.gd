class_name BattleScene
extends Node2D


# @onready var log_win := $LoggerWindow as Window 
@onready var timer := $Timer as Timer
@onready var counter := $Counter as Counter
@onready var round_counter:= $"Round counter" as Label
@onready var start_button := $"Start button" as Button

var cards_on_table: Array[Card] = []
var cards_in_hand: Array[Card] = []
var card_cursor := Cursor.new()
var cur_card: Card :
	get():
		return self.cards_on_table[self.card_cursor.index] if self.cards_on_table.size() != 0 else null

var available_combos: Array = Combos.COMBOS.keys()
var combos_on_table: Array[Combo] = []
var combo_cursor := Cursor.new()
var cur_combo: Combo :
	set(val): return
	get(): return null if self.combos_on_table.size() == 0 else self.combos_on_table[0]

var round_count := 2

var effects: Array[Effect] = []
var used_effects: Array[Effect]= []

# If `true` allow to play card by pressing `Enter` or `Space`
var is_turn_based_mode := true 

enum BATTLE_STAGE {
	ROUND_PREPARATION,
	ROUND_PLAYING,
}

signal next_card_key_pressed


func _ready() -> void:
	Events.connect_events({
		battle_started = self.start_round_preparation,

		round_started = self.on_round_started,
		round_ended = self.on_round_ended,
		round_exit = self.on_round_exit,

		card_started = self.on_card_started,
		card_ended = self.on_card_ended,
		card_exit = self.on_card_exit,

		combo_started = self.on_combo_started,
		combo_ended = self.on_combo_ended,
		combo_exit = self.on_combo_exit,
	})

	# self.next_card_key_pressed.connect(func (): print('input'))

	Game.battle = self
	self.round_counter.text = str(self.round_count)
	Events.battle_started.emit()
	# self.start_round_preparation()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('ui_accept'):
		self.next_card_key_pressed.emit()


func start_round_preparation() -> void:
	self.start_button.disabled = false
	self.counter.show_score_panel()
	Events.round_preparation_started.emit()
	var configs := [
		{
			'card_name': 'fist',
			'type': Card.BODY_PART.ARM_STRIKE,
			'points': 2,
			'multiplier': 1,
		},
		{
			'card_name': 'knee strike',
			'type': Card.BODY_PART.LEG_STRIKE,
			'points': 3,
			'multiplier': 1,
		},
		{
			'card_name': 'elbow',
			'type': Card.BODY_PART.ARM_STRIKE,
			'points': 5,
			'multiplier': 1,
		},
		{
			'card_name': 'fist',
			'type': Card.BODY_PART.ARM_STRIKE,
			'points': 2,
			'multiplier': 1,
		},
	]
	var spawn_pos := Vector2(350, 200)

	for i in len(configs):
		self.spawn_card(i, configs[i], spawn_pos)
		spawn_pos.x += 150

	# var e := Effects.EFFECTS['Extra points'] as Effect
	# var c := self.cards_on_table[-1]
	# # TODO: where this effect should store (in card or in battle scene)
	# e.bind_to(c)
	# c.add_effect(e)	
	# self.apply_effect(e, self.counter)


# TODO: move `check_combos()` in round preparation stage
func start_round() -> void:
	self.start_button.disabled = true
	self.check_combos()

	Events.round_started.emit()
	self.round_count -= 1
	if self.cards_on_table.size() == 0: return

	self.card_cursor.set_size(self.cards_on_table.size())
	self.combo_cursor.set_size(self.combos_on_table.size())
	
	if self.is_turn_based_mode:
		self.play_card()
	else:
		self.timer.start()


func end_round() -> void:
	self.round_counter.text = str(self.round_count)
	self.timer.stop()

	await self.counter.update_round_score()
	await get_tree().create_timer(1).timeout
	for e in self.effects:
		if e.activation_time == Effect.ACTIVATION_TIME.ROUND_END:
			e.activate()

	self.combos_on_table.clear()
	self.combo_cursor.reset()

	for card in self.cards_on_table:
		card.queue_free()
	self.cards_on_table.clear()
	self.card_cursor.reset()

	self.effects.clear()

	Events.round_exit.emit()


func play_card() -> void:
	var card := self.cur_card
	var combo := self.cur_combo

	if combo and card == combo.start_card:
		Events.combo_started.emit(combo)

	Events.card_started.emit(card);\
		card.play();\
		if (self.is_turn_based_mode):
			await self.next_card_key_pressed
	Events.card_ended.emit(card)

	if card.is_all_effects_activated():
		Events.card_exit.emit(card)

	if combo and card == combo.end_card:
		Events.combo_ended.emit(combo)
		# combo.apply_effect()	
		if combo.is_all_effects_activated():
			Events.combo_exit.emit(combo)

	if self.card_cursor.index == self.cards_on_table.size():
		Events.round_ended.emit()
		self.end_round()
	elif self.is_turn_based_mode:
		self.play_card()


func spawn_card(index: int, config: Dictionary, pos: Vector2) -> void:
	var card := CardFactory.create_with_binding(
		self,
		func (c: Card) -> void:
			c.index = index
			c.add_tags(config)
			c.position = pos
	)
	self.cards_on_table.append(card)


func check_combos() -> void:
	var i := 0
	var step: int
	while i < self.cards_on_table.size():
		step = 1
		for combo_name in self.available_combos:
			var combo := self.create_combo(
				combo_name,
				self.cards_on_table.slice(i)
			)
			if combo != null:
				self.combos_on_table.append(combo)
				step = combo.length
				break

		i += step


func create_combo(name: StringName, cards: Array[Card]) -> Combo:
	var combo := ComboFactory.create(name, cards)
	return combo


func add_effect(e: Effect) -> void:
	self.effects.append(e)


func apply_effect(e: Effect, to: Variant) -> void:
	e.set_target(to)
	to.add_effect(e)
	self.add_effect(e)


func activate_effects(time: Effect.ACTIVATION_TIME) -> void:
	var effects_on_time: Array[Effect] = self.effects.filter(
		func (e: Effect):
			return e.activation_time == time
	)
	for e in effects_on_time:
		e.activate()

	# effects that are not activated on `time`
	self.effects = self.effects.filter(
		func (e: Effect):
			return effects_on_time.find(e) == -1
	)
	self.used_effects.append_array(effects_on_time)

func on_round_preparation_started() -> void: pass
func on_round_started() -> void:
	# for c in self.combos_on_table:
	# 	self.counter.add(c.points, c.multiplier)
	self.activate_effects(Effect.ACTIVATION_TIME.ROUND_START)	

# TODO: reset counter effects
func on_round_ended() -> void:
	self.activate_effects(Effect.ACTIVATION_TIME.ROUND_END)	

# TODO: clear totems effects
func on_round_exit() -> void:
	self.effects.clear()
	self.used_effects.clear()

	if self.round_count != 0:
		self.start_round_preparation()
	else:
		Events.battle_ended.emit()
		print('battle end')


func on_card_started(c: Card) -> void:
	# print('card started: ', c.index, ' cur index: ', self.card_cursor.index)
	var effs: Array[Effect] = c.effects.filter(
		func (e: Effect):
			return e.activation_time == Effect.ACTIVATION_TIME.CARD_START
	)
	for e in effs:
		e.activate()

func on_card_ended(c: Card) -> void:
	self.card_cursor.move_foward()
	c.scale = Vector2.ONE

	var effects: Array[Effect] = c.effects.filter(
		func (e: Effect):
			return e.activation_time == Effect.ACTIVATION_TIME.CARD_END
	)
	for e in effects:
		e.activate()

func on_card_exit(c: Card) -> void:
	c.reset_effects()


func on_combo_started(c: Combo) -> void:
	# print('combo started: ', c.name, ' index: ', self.combo_cursor.index)
	match (c.effect.activation_time):
		Effect.ACTIVATION_TIME.CARD_START, Effect.ACTIVATION_TIME.CARD_END:
			c.apply_effect_to_cards()
		Effect.ACTIVATION_TIME.COMBO_START:
			for card in c.cards:
				c.effect.set_target(card)
				c.effect.activate()
	

func on_combo_ended(c: Combo) -> void:
	self.combo_cursor.move_foward()

	var effects: Array[Effect] = c.effects.filter(
		func (e: Effect):
			return e.activation_time == Effect.ACTIVATION_TIME.COMBO_END
	)

func on_combo_exit(c: Combo) -> void:
	c.reset_effects()

func on_effect_applyed(e: Effect) -> void: pass
func on_effect_activated(e: Effect) -> void: pass
