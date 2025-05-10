extends Control
class_name CardPlace

const SIZE: Vector2i = Vector2i(40, 40)

@onready var panel: Panel = $Panel as Panel


func _ready() -> void:
	self.custom_minimum_size = SIZE


func get_card() -> Card:
	return self.panel.data
