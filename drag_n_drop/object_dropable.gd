extends Control
class_name ObjectDropable

var data = null

# func _get_drag_data(at_position: Vector2) -> Variant:
#     return self.get_child(0)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data != null


func _drop_data(at_position: Vector2, data: Variant) -> void:
	self.data = data.duplicate()
	self.add_child(self.data)
	
	data.get_parent().remove_child(data)
