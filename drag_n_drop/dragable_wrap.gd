extends Control
class_name DraggableWrap

var obj_to_drag: Variant = null :
	set = __set_obj
var parent: Variant = null


func _init(obj: Variant, parent: Variant) -> void:
	self.obj_to_drag = obj
	self.parent = parent


func _get_drag_data(at_position: Vector2) -> Variant:
	var preview: Control = self.obj_to_drag.duplicate()  
	preview.size = self.obj_to_drag.size
	set_drag_preview(DragNDropPreview.new(preview))
	return DragData.new(self.parent, self.obj_to_drag)


func __set_obj(obj: Variant) -> void:
	if obj == null:
		self.remove_child(self.obj_to_drag)
		obj_to_drag = null
	else:
		self.add_child(obj)
		obj.set_anchors_and_offsets_preset(PRESET_TOP_LEFT, PRESET_MODE_KEEP_SIZE)
		# obj.set_anchors_preset(PRESET_TOP_LEFT)
		obj_to_drag = obj
		self.custom_minimum_size = obj.size
