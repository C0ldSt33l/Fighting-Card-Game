extends Control
class_name ChooseEnemyScene


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
	for i in len(self.enemy_cards):
		var c := self.enemy_cards[i]
		c.required_score = randi_range(1, 1000)
		c.image_rect.modulate += colors[i]
