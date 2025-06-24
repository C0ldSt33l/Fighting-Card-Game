extends Control
class_name ChooseEnemyScene


var min_enemy_hp: int = PlayerConfig.min_enemy_hp + 200 * PlayerConfig.defeated_monster_count
var max_enemy_hp: int = PlayerConfig.max_enemy_hp + 200 * PlayerConfig.defeated_monster_count

#TODO: fill test configs
const ENEMY_CONFIGS: Array[Dictionary] = [
	{
		enemy_name = 'вурдалак',
		image = preload("res://assets/tmp enemy/alghoul2.png"),
	},
	{
		enemy_name = 'орк-громила',
		image = preload("res://assets/tmp enemy/orc.png"),
	},
	{
		enemy_name = 'весник смерти',
		image = preload("res://assets/tmp enemy/death2.png"),
	},
	{
		enemy_name = 'череп-олень',
		image = preload("res://assets/tmp enemy/scull_deer2.png"),
	},

	{
		enemy_name = 'вурдалак',
		image = preload("res://assets/tmp enemy/alghoul2.png"),
	},
	{
		enemy_name = 'орк-громила',
		image = preload("res://assets/tmp enemy/orc.png"),
	},
	{
		enemy_name = 'весник смерти',
		image = preload("res://assets/tmp enemy/death2.png"),
	},
	{
		enemy_name = 'череп-олень',
		image = preload("res://assets/tmp enemy/scull_deer2.png"),
	},
]
const CONSTRAINTS: Array[String] = [
	'Слабость', # decrease card point
	'Один раунд', # player has only one round in battle
	'Без сбросов', # player has no rerolls
	'Расточительность', # for each combo player money decrease

	'Слабость', # decrease card point
	'Один раунд', # player has only one round in battle
	'Без сбросов', # player has no rerolls
	'Расточительность', # for each combo player money decrease
]
const REWARDS: Array[String] = [
	'Доли Духов',
	'Чёрная Сталь',
	'Мощь Гор',

	'Доли Духов',
	'Чёрная Сталь',
	'Мощь Гор',
]
const COLORS: Array[Color] = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.BROWN,
]

@onready var background: Panel = $Background
@onready var enemy_card_container: HBoxContainer = $"Enemy card container"
var enemy_cards: Array[EnemyCard] :
	get():
		var cards: Array[EnemyCard]
		cards.assign(self.enemy_card_container.get_children())
		return cards

@onready var reroll_count: int :
	set(val):
		reroll_count = val
		self.reroll_btn.text = 'Сброс: %s' % val
		if val < 1:
			self.reroll_btn.disabled = true
@onready var reroll_btn: Button = $"Reroll btn"




func _ready() -> void:
	self.reroll_count = 2
	for i in len(self.enemy_cards):
		var ec := self.enemy_cards[i]
		var d: Dictionary = ENEMY_CONFIGS.pick_random()
		ec.setup(
			d.enemy_name,
			d.image,
			randi_range(self.min_enemy_hp, self.max_enemy_hp),
			CONSTRAINTS.pick_random(),
			REWARDS.pick_random(),
		)
		ec.change_color(COLORS.pick_random())

		#TODO: make it depend on run progression (enemy rarity/type, lvl or etc.)
		ec.choosed.connect(self.on_enemy_choosed)

	await get_tree().process_frame
	await self.start_opening_animation()

	for c in self.enemy_cards:
		c.mouse_filter = Control.MOUSE_FILTER_STOP


func start_opening_animation() -> void:
	var card_final_pos_y := self.enemy_cards[0].position.y
	for c in self.enemy_cards:
		c.position.y += get_window().size.y / 2 + self.enemy_cards[0].size.y
	for i in len(self.enemy_cards):
		var c := self.enemy_cards[i]
		await create_tween().tween_property(
			c,
			'position:y',
			card_final_pos_y,
			1
		).finished


func on_enemy_choosed(ec: EnemyCard) -> void:
	PlayerConfig.enemy_data = ec.get_enemy_data()

	SceneManager.__last_scene_type = SceneManager.SCENE.CHOOSE_ENEMY 
	# SceneManager.call_deferred('open_new_scene_by_name', SceneManager.SCENE.LOADING)
	SceneManager.close_current_scene()
	

func reroll_enemy() -> void:
	self.reroll_count -= 1
	for ec in self.enemy_cards:
		var d: Dictionary = ENEMY_CONFIGS.pick_random()
		ec.setup(
			d.enemy_name,
			d.image,
			randi_range(self.min_enemy_hp, self.max_enemy_hp),
			CONSTRAINTS.pick_random(),
			REWARDS.pick_random(),
		)
		ec.change_color(COLORS.pick_random())
