class_name BattleScene
extends Node2D


@onready var logger := $Logger as Logger 
@onready var timer := $Timer as Timer
@onready var counter := $Counter as Counter

var card_cursor := 0 :
	set(val): card_cursor = clampi(val, 0, self.cards_on_table.size())
var cards_on_table: Array[Card] = []
var cards_in_hand: Array[Card] = []

var available_combos: Array = Combos.COMBOS.keys()
var combos_on_table: Array[Combo] = []
var cur_combo: Combo :
	set(val): return
	get(): return null if self.combos_on_table.size() == 0 else self.combos_on_table[0]

var effects: Array[Effect] = []


func _ready() -> void:
	Game.battle = self
	# self.connect_signals(self, {
	# 	round_started = null,
	# 	round_ended = null,
	# 	round_tick = null,
	# })
	# Utils.connect_signals(self.counter, {
	# 	'points_changed': self.logger.change_points_log,
	# 	'multiplier_changed': self.logger.change_multiplier_log,
	# 	'total_score_changed': self.logger.change_total_score_log,
	# })

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

	for config in configs:
		self.spawn_card(config, spawn_pos)
		spawn_pos.x += 150

	for c in self.cards_on_table:
		c.energy = Card.ENERGY.KI

	var e := Effects.EFFECTS['Multiplier+'] as Effect
	e.bind_to(self)
	e.set_target(self.cards_on_table[0])
	Game.battle.add_effect(e)

	var post_round_effect := Effects.EFFECTS['Double Score'] as Effect
	post_round_effect.bind_to(self)
	post_round_effect.set_target(self.counter)
	Game.battle.add_effect(post_round_effect)

	# print(inst_to_dict(self))
	Events.round_prepare_started.emit()


func start_round() -> void:
	Events.round_started.emit()
	if self.cards_on_table.size() == 0: return
	self.check_combos()
	for e in self.effects:
		if e.activation_time == Effect.ACTIVATION_TIME.ROUND_START:
			e.activate()
	self.timer.start()


func end_round() -> void:
	Events.round_exit.emit()
	self.timer.stop()

	await self.counter.update_round_score()
	await get_tree().create_timer(1).timeout
	for e in self.effects:
		if e.activation_time == Effect.ACTIVATION_TIME.ROUND_END:
			e.activate()

	for c in self.combos_on_table:
		c.free()
	self.combos_on_table.clear()
	self.card_cursor = 0

	for card in self.cards_on_table:
		card.queue_free()
	self.cards_on_table.clear()
	self.effects.clear()

	Events.round_prepare_started.emit()


func play_card() -> void:
	var card := self.cards_on_table[self.card_cursor]
	var combo := self.cur_combo

	if combo and card == combo.start_card:
		Events.combo_started.emit(combo)
	elif combo and card == combo.end_card:
		Events.combo_ended.emit(combo)
		# combo.apply_effect()	
		self.combos_on_table.erase(combo)
		Events.combo_exit.emit()

	Events.card_started.emit(card)
	card.play()
	Events.card_exit.emit(card)

	self.counter.points += card.points
	self.counter.multiplier += card.multiplier

	self.card_cursor += 1
	if self.card_cursor == self.cards_on_table.size():
		Events.round_ended.emit()
		self.end_round()


func spawn_card(config: Dictionary, pos: Vector2) -> void:
	var card := CardFactory.create_with_binding(
		self,
		func (c: Card) -> void:
			c.add_tags(config)
			c.position = pos
			#c = Utils.connect_signals(c, {
				#created = self.logger.obj_has_created_log,
				#played = self.logger.card_has_played_log,
				#destroyed = self.logger.obj_has_destroyed_log,
				#prop_changed = self.logger.obj_prop_changed_log,
			#})
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

	for c in self.combos_on_table:
		c.apply_effect()	


func create_combo(name: StringName, cards: Array[Card]) -> Combo:
	var combo := ComboFactory.create(name, cards)
	if combo == null: return null

	#Utils.connect_signals(combo, {
		#created = self.logger.obj_has_created_log,
		#played = self.logger.combo_has_activated,
		#destroyed = self.logger.obj_has_destroyed_log,
	#})

	return combo


func add_effect(e: Effect) -> void:
	self.effects.append(e)
