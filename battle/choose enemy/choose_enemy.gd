extends Control
class_name ChooseEnemyScene

#TODO: fill test configs
var enemy_confs: Array[Dictionary] = [
	{
		enemy_name = 'weak enemy',
		image_path = 'res://assets/tmp enemy/enemy.jpg',
	},
	{
		enemy_name = 'middle enemy',
		image_path = 'res://assets/tmp enemy/enemy.jpg',
	},
	{
		enemy_name = 'strong enemy',
		image_path = 'res://assets/tmp enemy/enemy.jpg',
	},
	{
		enemy_name = 'random name 1',
		image_path = 'res://assets/tmp enemy/enemy.jpg',
	},
	{
		enemy_name = 'random name 2',
		image_path = 'res://assets/tmp enemy/enemy.jpg',
	},
	{
		enemy_name = 'random name 3',
		image_path = 'res://assets/tmp enemy/enemy.jpg',
	},
]

@onready var background: Panel = $Background
@onready var enemy_card_container: HBoxContainer = $"Enemy card container"
var enemy_cards: Array[EnemyCard] :
	get():
		var cards: Array[EnemyCard]
		cards.assign(self.enemy_card_container.get_children())
		return cards


const CARD_SCENE := preload("res://battle/choose enemy/enemy card/enemy_card.tscn")



func _ready() -> void:
	var colors: Array[Color] = [
		Color.RED,
		Color.BLUE,
		Color.GREEN,
	]
	colors.shuffle()
	self.enemy_confs.shuffle()
	var confs: Array[Dictionary] = self.enemy_confs.slice(0, 3)
	for i in len(self.enemy_cards):
		var c := self.enemy_cards[i]
		var d := confs[i]
		c.setup(d.enemy_name, d.image_path, randi_range(1, 1000))

		#TODO: make it depend on run progression (enemy rarity/type, lvl or etc.)
		c.image_rect.modulate += colors[i]
		var col := colors[i]
		col.s = 100
		col.v = 0.5
		c.stylebox.bg_color = col
		c.choosed.connect(self.on_enemy_choosed)

	await get_tree().process_frame
	await self.start_opening_animation()

	for c in self.enemy_cards:
		c.connect_mouse_signals()


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
			2
		).finished


func on_enemy_choosed(ec: EnemyCard) -> void:
	#TODO: move in new scene:
	#choose enemy -> loading -> battle
	print('enemy choosed')
