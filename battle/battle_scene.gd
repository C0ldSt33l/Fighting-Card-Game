class_name BattleScene
extends Control


@onready var timer: Timer = $Timer as Timer
@onready var start_button: Button = $"Start button" as Button

@onready var counter: Counter = $Counter as Counter
#TODO: add another enemy props and init it in `_ready()`
@onready var required_score: int = 2

@onready var deck_dict: Array[Dictionary] = Sql.select_battle_cards()
@onready var hand: Hand = $Hand as Hand
@onready var table: Table = $Table as Table

var CARD_TEMPLATE: Card = preload("res://battle/card/card.tscn").instantiate() as Card
var cards_on_table: Array[Card] :
	get(): return self.table.cards
var cards_in_hand: Array[Card] :
	get(): return self.hand.cards
var card_cursor: Cursor = Cursor.new(Cursor.TYPE.CARDS)
var cur_card: Card :
	get(): return self.cards_on_table[self.card_cursor.index] if self.card_cursor.index < self.cards_on_table.size() else null
var first_card: Card :
	get(): return self.cards_on_table[0] if self.cards_on_table.size() > 0 else null
var last_card: Card :
	get(): return self.cards_on_table[-1] if self.cards_on_table.size() > 0 else null
var played_cards: Array[Card] = []

var COMBO_TEMPLATE: SimpleComboView = preload("res://battle/combo/simple_view/simple_combo_view.tscn").instantiate()
var available_combos: Dictionary = Combos.COMBOS
var combos_on_table: Array[ComboData] :
	get():
		var a: Array[ComboData]
		a.assign(self.table.combos.map(func (c: FullComboView): return c.get_combo_data()))
		return a
var combo_cursor: Cursor = Cursor.new(Cursor.TYPE.COMBOS)
var cur_combo: ComboData :
	get(): return self.combos_on_table[self.combo_cursor.index] if self.combo_cursor.index < self.combos_on_table.size() else null
var first_combo: ComboData :
	get(): return self.combos_on_table[0] if self.combos_on_table.size() > 0 else null
var last_combo: ComboData :
	get(): return self.combos_on_table[-1] if self.combos_on_table.size() > 0 else null

@onready var round_counter: Label = $"Round counter" as Label
# TODO: move in player config
@onready var round_count: int = 2 :
	set(val):
		round_count = val
		self.round_counter.text = str(val)
@onready var reroll_btn: Button = (self.hand as Hand).reroll_btn
@onready var reroll_count: int = 4 :
	set(val):
		reroll_count = val
		self.reroll_btn.text = 'Сброс: %s' % [val] 
		if val < 1:
			self.reroll_btn.disabled = true

var earned_money: int = 0

var effects: Array[Effect] = []
var used_effects: Array[Effect]= []

# TODO: move to config file
# If `true` allow to play card by pressing `Enter` or `Space`
var is_turn_based_mode: bool = true 

signal next_card_key_pressed


func _ready() -> void:
	Events.connect_events({
		battle_started = self.start_round_preparation,
		battle_ended = self.on_battle_ended,

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

	# Events.drag_completed.connect(
	# 	func (f, s):
	# 		print('-----------------')
	# 		for p: CardPlace in self.table.card_places_container.get_children():
	# 			print('c: ', p.card)
	# 			print('d: ', p.panel.held_data)
	# 			print()
	# )

	#TODO: move init seg in separate func
	self.reroll_btn.pressed.connect(self.reroll)
	# TODO: add this props in player config
	self.reroll_count = 4
	self.round_count = 2

	print('EMEMY SCORE: ', self.required_score)

	Game.battle = self
	Events.battle_started.emit()


# TODO: init hand, table, totem segment and comsumable segment
func __init_components() -> void:
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('ui_accept'):
		self.next_card_key_pressed.emit()


func start_round_preparation() -> void:
	self.start_button.disabled = false
	self.counter.show_score_panel()
	Events.round_preparation_started.emit()

	var hand_size := PlayerConfig.hand_size - self.hand.card_count
	var confs := self.get_hand_configs(hand_size)
	for i in len(confs):
		var c := confs[i]
		self.spawn_card(c)

	var i := 0
	for combo_name in self.available_combos:
		#if i == 0: continue
		self.spawn_combo(combo_name, self.available_combos[combo_name])
		i += 1
	var last_combo := self.hand.combos[-1]
	
	# var e := Effects.get_effect('Multiplying')
	# self.cards_in_hand[0].bind_effect(e)


# TODO: move `check_combos()` in round preparation stage
func start_round() -> void:
	self.cards_on_table = self.table.get_cards()
	if self.cards_on_table.size() == 0: return 

	self.start_button.disabled = true

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
	Events.round_exit.emit()

	self.round_counter.text = str(self.round_count)
	self.timer.stop()


	await self.counter.update_round_score()
	await get_tree().create_timer(1).timeout

	#NOTE: maybe it will await so show reward screen takes time
	if self.counter.total_score >= self.required_score:
		Events.battle_ended.emit()
		return

	self.combos_on_table.clear()

	var card_names := self.cards_on_table.map(func (c: Card): return c.card_name)
	self.deck_dict = self.deck_dict.filter(func (conf: Dictionary): return conf.Name not in card_names)
	self.played_cards.append_array(self.cards_on_table)
	self.cards_on_table.clear()
	self.table.remove_cards()

	self.card_cursor.reset()
	self.combo_cursor.reset()

	self.effects.clear()
	self.used_effects.clear()

	if self.round_count != 0:
		self.start_round_preparation()
	else:
		Events.battle_ended.emit()
		print('battle end')



func play_card() -> void:
	var card := self.cur_card
	var combo := self.cur_combo

	if combo and card == combo.first_card:
		Events.combo_started.emit(combo)

	Events.card_started.emit(card);\
		card.play();\
		if (self.is_turn_based_mode):
			await self.next_card_key_pressed
	Events.card_ended.emit(card)

	if self.is_all_effects_activated_on(card):
		Events.card_exit.emit(card)

	if combo and card == combo.last_card:
		Events.combo_ended.emit(combo)
		if self.is_all_effects_activated_on(combo):
			Events.combo_exit.emit(combo)

	print('card index: ', card.index)
	print('cards on table: ', self.cards_on_table.size() - 1)

	if self.card_cursor.index == self.cards_on_table.size():
		print('end round fuck you')
		Events.round_ended.emit()

	if self.card_cursor.index == self.cards_on_table.size():
		self.end_round()
	elif self.is_turn_based_mode:
		self.play_card()


func spawn_card(conf: Dictionary) -> void:
	var materials := M.MATERIAL.values()
	var card := Utils.Factory.create(
		CARD_TEMPLATE,
		func (c: Card) -> void:
			c.set_main_props(conf)
			c._material = materials[randi_range(0, materials.size() - 1)]
			c.point = randi_range(1, 9)
	)
	self.hand.add_card(card)
	self.cards_in_hand.append(card)

func spawn_combo(name: String, conf: Dictionary) -> void:
	var materials := M.MATERIAL.values()
	var combo: SimpleComboView = Utils.Factory.create(
		self.COMBO_TEMPLATE,
		func (c: SimpleComboView):
			c.combo_name = name
			c.pattern.assign(conf.pattern)
			c.effects.append(Effects.get_effect(conf.effect))
			for p in conf.props:
				c[p] = conf.props[p]
			c._material = materials[randi_range(0, materials.size() - 1)]
	)
	self.hand.add_combo(combo)
	# combo.make_little_view()


func reroll() -> void:
	self.reroll_count -= 1

	var size := self.hand.card_count
	var configs := self.get_hand_configs(size)
	self.hand.remove_all_cards()
	for c in configs:
		self.spawn_card(c)


func get_hand_configs(size: int) -> Array[Dictionary]:
	var hand_confs: Array[Dictionary]
	hand_confs.assign(
		Utils.get_array_with_uniq_nums(
			size, self.deck_dict.size() - 1
		)
		.map(func (el: int): return self.deck_dict[el])
	)
	return hand_confs


func add_effect(e: Effect) -> void:
	self.effects.append(e)


func apply_effect(e: Effect, to: Variant) -> void:
	e.set_target(to)
	to.add_effect(e)
	self.add_effect(e)


func _get_filtered_effects(effects: Array[Effect], filter: Callable, args: Array) -> Array[Effect]:
	return filter.bindv(args).call(effects)

func activate_effects(effects: Array[Effect]) -> void:
	for e in effects:
		print('activated')
		e.activate()

func activate_filtered_effects(filter: Callable, args: Array) -> void:
	var effects := self._get_filtered_effects(self.effects, filter, args)
	self.activate_effects(effects)

func reset_effects(effects: Array[Effect]) -> void:
	for e in effects:
		e.reset()

func reset_filtered_effects(filter: Callable, args: Array) -> void:
	var effects := self._get_filtered_effects(self.used_effects, filter, args)
	for e in effects:
		e.reset()

func is_all_effects_activated_on(target: Variant) -> bool:
	return Utils.Filter.BY_TARGET(self.effects, target).size() == 0


func get_effects_from(obj: Variant) -> Array[Effect]:
	const TYPE := Effect.TARGET_TYPE
	var effects: Array[Effect] = []
	for e: Effect in obj.effects:
		match e.target_type:
			TYPE.SELF_CARD, TYPE.SELF_COMBO:
				effects.append(e.set_target(e.caster))

			TYPE.NEXT_CARD:
				var i: int = e.caster.index + 1
				if (i < self.cards_on_table.size()):
					effects.append(e.set_target(self.cards_on_table[i]))
			TYPE.PREV_CARD:
				var i: int = e.caster.index - 1
				if (i > -1):
					effects.append(e.set_target(self.cards_on_table[i]))
			TYPE.FIRST_CARD:
				effects.append(e.set_target(self.first_card))
			TYPE.LAST_CARD:
				effects.append(e.set_target(self.last_card))
			TYPE.CARD_IN_COMBO:
				for c: Card in e.caster.cards:
					effects.append(e.set_target(c))
			TYPE.FIRST_CARD_IN_COMBO:
				effects.append(e.set_target(e.caster.first_card))
			TYPE.LAST_CARD_IN_COMBO:
				effects.append(e.set_target(e.caster.last_card))

			TYPE.NEXT_COMBO:
				var i: int = e.caster.index + 1
				if (i < self.combos_on_table.size()):
					effects.append(e.set_target(self.combos_on_table[i]))
			TYPE.PREV_COMBO:
				var i: int = e.caster.index - 1
				if (i > -1):
					effects.append(e.set_target(self.combos_on_table[i]))
			TYPE.FIRST_COMBO:
				self.effects.append(e.set_target(self.first_combo))
			TYPE.LAST_COMBO:
				effects.append(e.set_target(self.last_combo))

			TYPE.CARD_CURSOR:
				effects.append(e.set_target(self.card_cursor))
			TYPE.COMBO_CURSOR:
				effects.append(e.set_target(self.combo_cursor))

			TYPE.SCORE:
				effects.append(e.set_target(self.counter))

			_:
				Utils.panic('NO SUCH TYPE IN EFFECT OR NOT IMPLEMENT HANDLER: target type: %s' % [str(TYPE.keys()[e.target_type])])
	return effects


func collect_all_effects() -> void:
	for c in self.cards_on_table:
		self.effects.append_array(self.get_effects_from(c))
	for c in self.combos_on_table:
		self.effects.append_array(self.get_effects_from(c))


func on_round_preparation_started() -> void: pass
func on_round_started() -> void:
	# TODO: move segment in round preparation segment
	for c in self.combos_on_table:
		self.counter.add(c.points, c.factor)
	
	self.collect_all_effects()
	self.activate_filtered_effects(
		Utils.Filter.BY_ACTIVATION_TIME,
		[Effect.ACTIVATION_TIME.ROUND_START]
	)
func on_round_ended() -> void:
	print('round is end')
	self.reset_filtered_effects(
		Utils.Filter.BY_RESET_TIME,
		[Effect.RESET_TIME.ROUND]
	)
	self.activate_filtered_effects(
		Utils.Filter.BY_ACTIVATION_TIME,
		[Effect.ACTIVATION_TIME.ROUND_END]
	)
# TODO: clear totems effects
func on_round_exit() -> void:
	pass

func on_card_started(c: Card) -> void:
	self.activate_filtered_effects(
		Utils.Filter.BY_ACTIVATION_ON_CARD,
		[Effect.ACTIVATION_TIME.CARD_START, c]
	)
func on_card_ended(c: Card) -> void:
	c.scale = Vector2.ONE
	self.card_cursor.move_foward()

	self.activate_filtered_effects(
		Utils.Filter.BY_ACTIVATION_ON_CARD,
		[Effect.ACTIVATION_TIME.CARD_END, c]
	)
func on_card_exit(c: Card) -> void:
	self.reset_filtered_effects(
		Utils.Filter.BY_RESET_ON_CARD,
		[c]
	)

func on_combo_started(c: ComboData) -> void:
	self.activate_filtered_effects(
		Utils.Filter.BY_ACTIVATION_ON_COMBO,
		[Effect.ACTIVATION_TIME.COMBO_START, c]
	)
func on_combo_ended(c: ComboData) -> void:
	self.combo_cursor.move_foward()

	self.activate_filtered_effects(
		Utils.Filter.BY_ACTIVATION_ON_COMBO,
		[Effect.ACTIVATION_TIME.COMBO_END, c]
	)
func on_combo_exit(c: ) -> void:
	self.reset_filtered_effects(
		Utils.Filter.BY_RESET_ON_COMBO,
		[c]
	)

func on_effect_applyed(e: Effect) -> void: pass
func on_effect_activated(e: Effect) -> void: pass


func on_battle_ended() -> void:
	print('BATTLE IS ENDED')
	self.earned_money += self.round_count
	PlayerConfig.enemy_data = null
