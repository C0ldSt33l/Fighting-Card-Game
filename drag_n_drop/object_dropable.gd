extends Control
class_name ObjectDropable

var held_data: Variant
var check: Callable


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return self.held_data == null and self.check.call(data)


func _drop_data(at_position: Vector2, data: Variant) -> void:
	self.held_data = data
	data.get_parent().remove_child(data)
	Events.drag_completed.emit(data, self.get_parent())
