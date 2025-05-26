extends Control
class_name CardPlace

const SIZE: Vector2i = Vector2i(40, 40)

@onready var panel: ObjectDropable = $Panel as ObjectDropable 
var index: int = -1
var card: Card = null


func _ready() -> void:
	Events.drag_completed.connect(self.on_drag_completed)
	self.panel.check = func(data: Variant) -> bool:
		return data is Card
	self.custom_minimum_size = SIZE


func get_card() -> Card:
	return self.panel.held_data


func add_card(c: Card) -> void:
	self.panel.add_child(c)
	c.size = self.card.background.size
	c.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)

	self.card = c
	c.index = self.index


func remove_card() -> void:
	self.panel.remove_child(self.panel.held_data)
	self.panel.held_data = null


func on_drag_completed(data: Variant, where: Variant) -> void:
	if self != where: return

	self.add_card(data)
