extends Control

var data = null

# func _get_drag_data(at_position: Vector2) -> Variant:
#     return self.get_child(0)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	self.data = data.duplicate()
	self.data.position = -0.25 * self.data.size
	self.add_child(self.data)
