class_name Hand
extends Control

@onready var background: Panel = $Background as Panel
@onready var margins: MarginContainer = $MarginContainer as MarginContainer
@onready var cards: GridContainer = $MarginContainer/GridContainer as GridContainer

var card_count_per_row: int = PlayerConfig.hand_size

var card_count: int :
	get(): return self.cards.get_child_count()


func _ready() -> void:
	self.cards.columns = self.card_count_per_row
	self.background.custom_minimum_size = self.size
	self.margins.custom_minimum_size = self.size


func add_card(c: Card) -> void:
	self.cards.add_child(c)


func remove_all_cards() -> void:
	var cards := self.cards.get_children()
	for c in cards:
		self.cards.remove_child(c)
