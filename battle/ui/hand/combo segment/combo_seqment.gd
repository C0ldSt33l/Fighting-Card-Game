extends Control
class_name ComboSeqment

@onready var combo_container: VBoxContainer = $"Background/MarginContainer/Combo Container"
var combos: Array[Combo] :
	get():
		var arr: Array[Combo]
		arr.assign(self.combo_container.get_children().map(func (w: DraggableWrap) -> Combo: return w.obj_to_drag as Combo))
		return arr


#TODO: handle drag n drop
func _ready() -> void:
	#self.combo_container.remove_child(
		#self.combo_container.get_child(0)
	#)
	
	pass

func add_combo(c: Combo) -> void:
	var wrapper := DraggableWrap.new(c, Game.battle.hand)
	self.combo_container.add_child(wrapper)


func add_combo_at_pos(c: Combo, pos: int) -> void:
	var wrapper := DraggableWrap.new(c, Game.battle.hand)
	self.combo_container.add_child(wrapper)
	self.combo_container.move_child(wrapper, pos)


func remove_combo(c: Combo) -> void:
	for w: DraggableWrap in self.combo_container.get_children():
		if w.obj_to_drag == c:
			w.remove_child(c)
			self.combo_container.remove_child(w)


func remove_combo_at_pos(pos: int) -> void:
	if pos >= self.combo_container.get_child_count(): return
	var w: DraggableWrap = self.combo_container.get_child(pos)
	w.remove_child(w.get_child(0))
	self.combo_container.remove_child(w)


func remove_all_combos() -> void:
	for c in self.combo_container.get_children():
		self.combo_container.remove_child(c)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data.data is Combo and data.data not in self.combos


func _drop_data(at_position: Vector2, data: Variant) -> void:
	data.from.remove_combo()
	self.add_combo(data.data)
