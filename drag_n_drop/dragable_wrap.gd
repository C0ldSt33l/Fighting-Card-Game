extends Control
class_name DraggableWrap

var obj_to_drag: Variant = null :
	set = __set_obj


func _init(obj: Variant) -> void:
	self.obj_to_drag = obj


func _get_drag_data(at_position: Vector2) -> Variant:
	var preview: Control = self.obj_to_drag.duplicate()  
	preview.size = self.obj_to_drag.size
	set_drag_preview(DragNDropPreview.new(preview))
	return DragData.new(Game.battle.hand, self.obj_to_drag)


func __set_obj(obj: Variant) -> void:
	if obj == null:
		self.remove_child(self.obj_to_drag)
		obj_to_drag = null
	else:
		self.add_child(obj)
		obj_to_drag = obj
		self.custom_minimum_size = obj.size
