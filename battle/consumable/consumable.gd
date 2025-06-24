extends Control
class_name Consumable

@onready var texture_rect: TextureRect = $TextureRect
@onready var image: Texture2D :
	set(val): self.texture_rect.texture = val
	get(): return self.texture_rect.texture

var comsumable_name: String = 'empty'
var description: String = 'do nothing'

var effect: Effect = null


func get_drag_preview() -> DragNDropPreview:
	return DragNDropPreview.new(self.texture_rect.duplicate())


func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(self.get_drag_preview())
	return DragData.new(self, self)
