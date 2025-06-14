extends TextureRect

func _get_drag_data(at_position: Vector2) -> Variant:
	var preview: TextureRect = self.duplicate()
	preview.size = self.size
	set_drag_preview(DragNDropPreview.new(preview))
	return self.get_parent()
