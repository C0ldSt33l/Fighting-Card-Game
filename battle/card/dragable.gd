extends Control 
class_name Dragable


func _get_drag_data(at_position: Vector2) -> Variant:
	var data := self.get_parent()
	self.set_drag_preview(
		DragNDropPreview.new(data.duplicate())
	)
	return data
