extends Control
class_name _Totem

var pos_idx: int

@onready var texture_rect: TextureRect = $TextureRect
@onready var image: Texture2D :
	set(val): self.texture_rect.texture = val
	get(): return self.texture_rect.texture

@export var totem_name: String = 'Empty'
@export var description: String = 'Do nothing'

var effect: Effect = null


func get_drag_preview() -> DragNDropPreview:
	return DragNDropPreview.new(self.texture_rect.duplicate())

func setup(name: String, desc: String, image: Texture2D, effect: Effect = null) -> void:
	self.totem_name = name
	self.description = desc
	self.image = image
	self.effect = effect
	

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(self.get_drag_preview())
	return DragData.new(self, self)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data.data is _Totem


func _drop_data(at_position: Vector2, data: Variant) -> void:
	Game.battle.totem_segment.swap_totems(self, data.data)
