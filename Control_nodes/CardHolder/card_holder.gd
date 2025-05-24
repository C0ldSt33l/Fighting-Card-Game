extends Control
@export var card_overlap: float = 40.0 # На сколько пикселей перекрывать предыдущую карту
@export var card_spacing: float = 1.0 # Базовое расстояние между картами
@onready var Background: Panel = $Background
var cards = []
var objs = []
func _ready() -> void:
	cards = Sql.select_all_type_cards_with_tags("UPGRADE")
	cards.append_array(Sql.select_all_type_cards_with_tags("UPGRADE"))
	for i in cards:
		create_card(i)
	update_layout()


func create_card(CardInfo: Dictionary) -> BaseCard:
	var card := CardCreator.create(
		CardInfo.card["TypeCard"],
		func(c: BaseCard):
			for key in CardInfo.card:
				c[key] = CardInfo.card[key]
			for tag in CardInfo.tags:
				c.tags.append(tag)
	)

	card.scale = Vector2(0.66, 0.66)
	add_child(card)
	objs.append(card)
	# Подписываемся на события наведения
	card.Background.mouse_entered.connect(Callable(self, "_on_card_mouse_enter").bindv([card]))
	card.Background.mouse_exited.connect(Callable(self, "_on_card_mouse_exited").bindv([card]))    	

	return card


func update_layout():
	if cards.is_empty():
		return
	var bg_width = Background.size.x

	var first_card = objs[0]
	var card_width = first_card.size.x
	var total_cards = cards.size()

	var total_required_width = card_width * total_cards
	var x: float = 0.0

	if bg_width >= total_required_width:
		# Карты помещаются целиком — распределяем их равномерно по ширине
		var spacing = bg_width / total_cards
		for i in range(total_cards):
			objs[i].position = Vector2(i * spacing, 0)
	else:
		
		var spacing = bg_width / (total_cards + 0.5)  # Небольшое сжатие
		for i in range(total_cards):
			objs[i].position = Vector2(i * spacing, 0)



func _on_card_mouse_enter(card: BaseCard):
	card.z_index = 100
	card.modulate = Color(255, 1, 1, 1.2)
	

func _on_card_mouse_exited(card: BaseCard):
	card.z_index = 0
	card.modulate = Color(1, 1, 1, 1)
