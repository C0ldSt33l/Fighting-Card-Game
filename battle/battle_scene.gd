class_name BattleScene
extends Control
@onready var option_segment: OptionSegment = $"Option segment"

@onready var player: TextureRect = $player
@onready var score_counter: ScoreCounter = $"Score counter"

@onready var totem_segment: TotemSegment = $"Totem segment"

@onready var timer: Timer = $Timer as Timer
@onready var start_button: Button = $"Start button" as Button

@onready var enemy: Enemy = $Enemy
@onready var enemy_hp: int :
	set(val): self.enemy.health = val
	get(): return self.enemy.health

var deck: Array[Card]
var discord_deck: Array[Card]
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

var COMBO_TEMPLATE: SimpleComboView = preload("res://battle/combo/simple_view/simple_combo_view.tscn").instantiate()
var available_combos: Dictionary = Combos.COMBOS
var combos_on_table: Array[FullComboView] :
	get():
		var a: Array[FullComboView]
		a.assign(self.table.combos)
		return a
var combo_cursor: Cursor = Cursor.new(Cursor.TYPE.COMBOS)
var cur_combo: FullComboView :
	get(): return self.combos_on_table[self.combo_cursor.index] if self.combo_cursor.index < self.combos_on_table.size() else null
var first_combo: FullComboView :
	get(): return self.combos_on_table[0] if self.combos_on_table.size() > 0 else null
var last_combo: FullComboView :
	get(): return self.combos_on_table[-1] if self.combos_on_table.size() > 0 else null

# TODO: move in player config
@onready var max_round_count: int :
	set(val):
		self.enemy.max_round_count = val
	get():
		return self.enemy.max_round_count
@onready var rest_round_count: int :
	set(val):
		self.enemy.rest_round_count = val
	get():
		return self.enemy.rest_round_count

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


	# Events.drag_completed.connect(
	# 	func (f, s):
	# 		print('-----------------')
	# 		for p: CardPlace in self.table.card_places_container.get_children():
	# 			print('c: ', p.card)
	# 			print('d: ', p.panel.held_data)
	# 			print()
	# )
	self._init_components()



	Game.battle = self
	Events.battle_started.emit()


# TODO: init hand, table, totem segment and comsumable segment
func _init_components() -> void:
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
	self._init_enemy()
	self._init_deck()
	self._init_table()
	self._init_hand()
	self._init_totem_segment()
	
	self.option_segment.menu_btn.pressed.connect(func():
		PlayerConfig.player_exit = true
		Events.battle_ended.emit())
	

func _init_enemy() -> void:
	var ed := PlayerConfig.enemy_data
	self.enemy.health = ed.required_score
	self.enemy.enemy_name = ed.name
	self.enemy.image = ed.image
	self.max_round_count = PlayerConfig.round_count
	self.rest_round_count = self.enemy.max_round_count

func _init_deck() -> void:
	var materials := M.MATERIAL.values()
	self.deck.assign(Sql.select_battle_cards().map(
		func (conf: Dictionary) -> Card:
			return Utils.Factory.create(
				CARD_TEMPLATE,
				func (c: Card) -> void:
					c.set_main_props(conf)
					c._material = materials[randi_range(0, materials.size() - 1)]
					# c.point = randi_range(1, 9)
			)
	)
	)

func _init_table() -> void:
	self.table.setup(6)

func _init_hand() -> void:
	self.reroll_count = PlayerConfig.reroll_count
	self.reroll_btn.pressed.connect(self.reroll)

func _init_totem_segment() -> void:
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('ui_accept'):
		self.next_card_key_pressed.emit()
		
func _on_inventory_button() -> void:
	SceneManager.__last_scene_type = SceneManager.SCENE.BATTLE
	SceneManager.open_new_scene_by_name(SceneManager.SCENE.INVENTORY)


func start_round_preparation() -> void:
	self.score_counter.reset()
	self.start_button.disabled = false
	Events.round_preparation_started.emit()

	var hand_size := PlayerConfig.hand_size - self.hand.card_count
	var cards := self.get_hand_configs(hand_size)
	for c in cards:
		self.spawn_card(c)

	for combo_name in self.available_combos:
		if self.hand.combos.size() >= 3:
			break
		self.spawn_combo(combo_name, self.available_combos[combo_name])
		# TODO: add used combo array
	var last_combo := self.hand.combos[-1]
	
	# var e := Effects.get_effect('Multiplying')
	# self.cards_in_hand[0].bind_effect(e)

# TODO: test with effect that run rount again
func process_round() -> void:
	self.start_round()
	while self.card_cursor.index < self.cards_on_table.size():
		#TODO: remove manual card playing
		await self.play_card(self.cur_card, self.cur_combo)
		
		print('CARD CURSOR: ', self.card_cursor.index)

		if self.card_cursor.index == self.cards_on_table.size():
			Events.round_ended.emit()
	self.end_round()

# TODO: move `check_combos()` in round preparation stage
func start_round() -> void:
	self.cards_on_table = self.table.get_cards()
	if self.cards_on_table.size() == 0: return 

	self.start_button.disabled = true

	Events.round_started.emit()
	self.rest_round_count -= 1
	if self.cards_on_table.size() == 0: return

	self.card_cursor.set_size(self.cards_on_table.size())
	self.combo_cursor.set_size(self.combos_on_table.size())
	
	# if self.is_turn_based_mode:
	# 	self.process_round()
	# else:
	# 	self.timer.start()


func end_round() -> void:
	Events.round_exit.emit()
	
	#self.
	self.timer.stop()
	
	
	await self.score_counter.update_round_score()
	self.enemy.health -= self.score_counter.round_score
	await get_tree().create_timer(1).timeout
	
	#NOTE: maybe it will await so show reward screen takes time
	print('ENEMY HP: ', self.enemy.health)
	if self.enemy.health <= 0:
		Events.battle_ended.emit()
		return
	
	self.combos_on_table.clear()

	for c in self.cards_on_table:
		c.effects.clear()
	self.discord_deck.append_array(self.cards_on_table)
	self.cards_on_table.clear()

	self.table.remove_all_combos()
	self.table.remove_all_cards()

	self.card_cursor.reset()
	self.combo_cursor.reset()

	self.effects.clear()
	self.used_effects.clear()

	if self.rest_round_count > 0:
		self.start_round_preparation()
	else:
		Events.battle_ended.emit()
		print('battle end')

func play_card(card: Card, combo: FullComboView) -> void:
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




func spawn_card(c: Card) -> void:
	# var materials := M.MATERIAL.values()
	# var card := Utils.Factory.create(
	# 	CARD_TEMPLATE,
	# 	func (c: Card) -> void:
	# 		c.set_main_props(conf)
	# 		c._material = materials[randi_range(0, materials.size() - 1)]
	# 		c.point = randi_range(1, 9)
	# )
	self.hand.add_card(c)
	self.cards_in_hand.append(c)

func spawn_combo(name: String, conf: Dictionary) -> void:
	var materials := M.MATERIAL.values()
	var combo: SimpleComboView = Utils.Factory.create(
		self.COMBO_TEMPLATE,
		func (c: SimpleComboView):
			c.combo_name = name
			c.pattern.assign(conf.pattern)
			c.effects.append(Effects.get_effect(conf.effect))
			for p in conf.props:
				if p == 'material':
					c._material = conf.props.material
				else:
					c[p] = conf.props[p]
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


func get_hand_configs(size: int) -> Array[Card]:
	var cards: Array[Card]
	cards.resize(size)

	if size > self.deck.size():
		var i := size - self.deck.size()
		self.deck.append_array(self.discord_deck.slice(0, i))
		for _i in i:
			self.discord_deck.pop_front()

	for i in size:
		var c: Card = self.deck.pick_random()
		cards[i] = c
		self.deck.erase(c)

	return cards


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
	if obj is _Totem:
		var e = obj.effect
		match e.target_type:
			TYPE.SELF_CARD, TYPE.SELF_COMBO:
				effects.append(e.set_target(e.caster))
			TYPE.CARD:
				for c in self.table.cards:
					effects.append(e.set_target(c))
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
				effects.append(e.set_target(self.score_counter))

			_:
				Utils.panic('NO SUCH TYPE IN EFFECT OR NOT IMPLEMENT HANDLER: target type: %s' % [str(TYPE.keys()[e.target_type])])
	else:		
		for e: Effect in obj.effects: 
			match e.target_type:
				TYPE.SELF_CARD, TYPE.SELF_COMBO:
					effects.append(e.set_target(e.caster))
				TYPE.CARD:
					for c in self.table.cards:
						effects.append(e.set_target(c))
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
					effects.append(e.set_target(self.score_counter))

				_:
					Utils.panic('NO SUCH TYPE IN EFFECT OR NOT IMPLEMENT HANDLER: target type: %s' % [str(TYPE.keys()[e.target_type])])
	return effects


func collect_all_effects() -> void:
	for t in self.totem_segment.totems:
		self.effects.append_array(self.get_effects_from(t))
	for c in self.combos_on_table:
		self.effects.append_array(self.get_effects_from(c))
	for c in self.cards_on_table:
		self.effects.append_array(self.get_effects_from(c))

func on_round_preparation_started() -> void: pass
func on_round_started() -> void:
	# TODO: move segment in round preparation segment
	for c in self.combos_on_table:
		self.score_counter.add(c.point, c.factor)
	
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

func on_combo_started(c: FullComboView) -> void:
	self.activate_filtered_effects(
		Utils.Filter.BY_ACTIVATION_ON_COMBO,
		[Effect.ACTIVATION_TIME.COMBO_START, c]
	)
func on_combo_ended(c: FullComboView) -> void:
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

	self.earned_money += 6 + self.rest_round_count
	PlayerConfig.battle_money = self.earned_money
	PlayerConfig.hand_money += self.earned_money
	PlayerConfig.upgrade_money += 1
	PlayerConfig.enemy_data = null

	PlayerConfig.player_won = self.enemy_hp <= 0

	PlayerConfig.defeated_monster_count += 1

	SceneManager.__last_scene_type = SceneManager.SCENE.BATTLE
	SceneManager.close_current_scene()
