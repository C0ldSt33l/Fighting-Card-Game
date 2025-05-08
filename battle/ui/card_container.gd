class_name CardContainer
extends Control

@onready var background: Panel = $Background as Panel
@onready var margins: MarginContainer = $MarginContainer as MarginContainer
@onready var cards: GridContainer = $MarginContainer/GridContainer as GridContainer

var card_count: int :
	get(): return self.cards.get_child_count()


func _ready() -> void:
	self.background.custom_minimum_size = self.size
	self.margins.custom_minimum_size = self.size


func add_card(c: Card) -> void:
	self.cards.add_child(c)
