extends Control
class_name Totem

@onready var texture_rect: TextureRect = $TextureRect

@export var totem_name: String = 'Empty'
@export var description: String = 'Do nothing'

var effect: Effect = null


func get_drag_preview() -> DragNDropPreview:
	return DragNDropPreview.new(self.texture_rect.duplicate())
