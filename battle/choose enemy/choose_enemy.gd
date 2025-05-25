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


func _ready() -> void:
	const colors: Array[Color] = [
		Color.RED,
		Color.BLUE,
		Color.GREEN,
	]
	self.enemy_confs.shuffle()
	var confs: Array[Dictionary] = self.enemy_confs.slice(0, 3)
	for i in len(self.enemy_cards):
		var c := self.enemy_cards[i]
		var d := confs[i]
		c.setup(d.enemy_name, d.image_path, randi_range(1, 1000))
		#TODO: make it depend on run progression (enemy rarity/type, lvl or etc.)
		c.image_rect.modulate += colors[i]

		c.choosed.connect(self.on_enemy_choosed)


func on_enemy_choosed(ec: EnemyCard) -> void:
	print('enemy choosed')
