extends Panel
class_name ComboPanel

var combo: Combo = null

func _get_drag_data(at_position: Vector2) -> Variant:
	var preview: Combo = self.combo
	# for p in self.combo.panels:
		# preview.panel_container.add_child(p.duplicate())
	set_drag_preview(DragNDropPreview.new(self.duplicate()))
	return self
