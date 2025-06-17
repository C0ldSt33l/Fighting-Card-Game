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
	for w in self.combo_container.get_children():
		if w.get_child(0) == c:
			w.remove_child(c)
			self.combo_container.remove_child(w)
			break


func remove_combo_at_pos(pos: int) -> void:
	var w := self.combo_container.get_child(pos)
	self.combo_container.remove_child(w)


func remove_all_combos() -> void:
	for w in self.combo_container.get_children():
		self.combo_container.remove_child(w)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data.data is Combo


func _drop_data(at_position: Vector2, data: Variant) -> void:
	data.from.remove_combo()
	self.add_combo(data.data)
