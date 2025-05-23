extends Control
class_name ObjectDropable

var held_data = null
var check: Callable


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return self.held_data == null and self.check.call(data)


func _drop_data(at_position: Vector2, data: Variant) -> void:
	data.get_parent().remove_child(data)
	self.held_data = data
	data.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)

	Events.drag_completed.emit(held_data, self.get_parent())
