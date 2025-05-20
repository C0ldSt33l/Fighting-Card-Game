extends Control
class_name DragNDropPreview

var data: Variant = null

var delta: float = 0.5

func _init(data: Control) -> void:
	self.data = data
	data.self_modulate.a = 0.5
	data.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)
	self.add_child(self.data)


func _physics_process(delta: float) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'position', get_global_mouse_position(), self.delta)
