extends Control 
class_name Dragable

static var i  := 0


func _get_drag_data(at_position: Vector2) -> Variant:
	var data := self.get_parent() as Control
	#print('combo panels: ', data.panels.size() )
	self.set_drag_preview(
		DragNDropPreview.new(data.duplicate())
	)
	Events.drag_started.emit(data)
	return data
