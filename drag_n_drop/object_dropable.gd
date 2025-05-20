extends Control
class_name ObjectDropable

var held_data = null
var check: Callable


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return self.held_data == null and self.check.call(data)


func _drop_data(at_position: Vector2, data: Variant) -> void:
	self.held_data = data.duplicate()
	self.held_data.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)
	self.add_child(self.held_data)

	data.get_parent().remove_child(data)
