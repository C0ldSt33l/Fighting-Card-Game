extends Control 
class_name Dragable


func _get_drag_data(at_position: Vector2) -> Variant:
	var data := self.get_parent() as Control
	self.set_drag_preview(
		DragNDropPreview.new(data.duplicate())
	)
	Events.drag_start.emit(data)
	return data
