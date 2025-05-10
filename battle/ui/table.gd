extends Control
class_name Table

@onready var places: HBoxContainer = $PanelContainer/MarginContainer/Places as HBoxContainer
var place_count: int = PlayerConfig.hand_size

const PLACE_SCENE := preload("res://battle/ui/card_place.tscn")


func _ready() -> void:
	for i in self.place_count:
		self.places.add_child(PLACE_SCENE.instantiate())


func get_cards() -> Array[Card]:
	var cards: Array[Card]
	for p: CardPlace in self.places.get_children():
		var card := p.get_card()
		if card:
			cards.append(card)
	return cards