extends Control
class_name DragNDropPreview

var data: Variant = null

var delta: float = 0.5

func _init(data: Control) -> void:
	self.z_index = 10
	self.data = data
	self.add_child(self.data)
	data.modulate.a = 0.5
	data.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)

#
#func _physics_process(delta: float) -> void:
	#var tween := get_tree().create_tween()
	#tween.tween_property(self, 'position', get_global_mouse_position(), self.delta)
