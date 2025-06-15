extends VBoxContainer


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Combo


func _drop_data(at_position: Vector2, data: Variant) -> void:
	data.get_parent().remove_child(data)
	self.add_child(data)
