extends Control
class_name CardPlace

const SIZE: Vector2i = Vector2i(40, 40)

@onready var panel: ObjectDropable = $Panel as ObjectDropable 


func _ready() -> void:
	self.panel.check = func(data: Variant) -> bool:
		return data is Card
	self.custom_minimum_size = SIZE


func get_card() -> Card:
	return self.panel.held_data_data


func remove_card() -> void:
	self.panel.remove_child(self.panel.held_data_data)
	self.panel.held_data_data = null
