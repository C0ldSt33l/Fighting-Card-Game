extends Node2D

@onready var logger := $Logger as Logger 
@onready var timer := $Timer as Timer
@onready var counter := $Counter as Counter

var cards_on_table: Array[Card] = []
var cur_card := 0

var available_combos: Array = Combos.COMBOS.keys()
var combos_on_table: Array[Combo] = []
var cur_combo: Combo :
	set(val): return
	get(): return null if self.combos_on_table.size() == 0 else self.combos_on_table[0]


func _ready() -> void:
	self.connect_sygnals(self.counter, {
		'points_changed': self.logger.change_points_log,
		'multiplier_changed': self.logger.change_multiplier_log,
		'total_score_changed': self.logger.change_total_score_log,
	})

	var configs := [
		{
			'card_name': 'fist',
			'type': Card.ACTION_TYPE.ARM_STRIKE,
			'dmg': 2
		},
		{
			'card_name': 'knee strike',
			'type': Card.ACTION_TYPE.LEG_STRIKE,
			'dmg': 3
		},
		{
			'card_name': 'elbow',
			'type': Card.ACTION_TYPE.ARM_STRIKE,
			'dmg': 5
		},
		{
			'card_name': 'fist',
			'type': Card.ACTION_TYPE.ARM_STRIKE,
			'dmg': 2
		},
	]
	var spawn_pos := Vector2(350, 200)

	for config in configs:
		self.spawn_card(config, spawn_pos)
		spawn_pos.x += 150


func start_round() -> void:
	self.timer.start()
	self.check_combos()


func end_round() -> void:
	self.timer.stop()

	self.counter.final_result()
	self.combos_on_table.clear()
	self.cur_card = 0
	for card in self.cards_on_table:
		card.queue_free()
	self.cards_on_table.clear()


func play_card() -> void:
	var card := self.cards_on_table[self.cur_card]
	var combo := self.cur_combo

	card.play()
	self.counter.points += card.dmg
	print('points: ' + str(self.counter.points))
	print('multilier: : ' + str(self.counter.multiplier))
	if combo and card == combo.activation_card:
		combo.apply_effect()	
		self.combos_on_table.erase(combo)

	self.cur_card += 1
	if self.cur_card == self.cards_on_table.size():
		self.end_round()


func spawn_card(config: Dictionary, pos: Vector2) -> void:
	var card := CardFactory.create_with_binding(
		self,
		func (c: Card) -> void:
			c.add_tags(config)
			c.position = pos
			c = self.connect_sygnals(c, {
				'created': self.logger.obj_has_created_log,
				'played': self.logger.card_has_played_log,
				'destroyed': self.logger.obj_has_destroyed_log,
			})
	)

	self.cards_on_table.append(card)


func select_first_combo() -> void:
	self.selected_combo = self.available_combos[0]


func select_second_combo() -> void:
	self.selected_combo = self.available_combos[1]


# NOTE: If there're 2 combos, one of them extends another,
# then the one, that goes before, will be activated
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
				step = combo.lenght
				break

		i += step


func create_combo(name: StringName, cards: Array[Card]) -> Combo:
	var combo := ComboFactory.create(name, cards)
	if combo == null: return null

	self.connect_sygnals(combo, {
		'created': self.logger.obj_has_created_log,
		'played': self.logger.combo_has_activated,
		'destroyed': self.logger.obj_has_destroyed_log,
	})

	return combo


func connect_sygnals(obj: Variant, what_to_what: Dictionary) -> Variant:
	for s in what_to_what:
		obj[s].connect(what_to_what[s])
	
	return obj
