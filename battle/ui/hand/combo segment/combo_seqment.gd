extends Control
class_name ComboSeqment

@onready var combo_container: VBoxContainer = $"Background/MarginContainer/Combo Container"
var combos: Array[Combo] :
	get():
		var arr: Array[Combo]
		arr.assign(self.combo_container.get_children().map(func (c: Control) -> Combo: return c.get_child(0) as Combo))
		return arr

#TODO: handle drag n drop
func _ready() -> void:
	#self.combo_container.remove_child(
		#self.combo_container.get_child(0)
	#)
	pass

func add_combo(c: Combo) -> void:
	var wrapper := Control.new()
	wrapper.custom_minimum_size = c.custom_minimum_size
	wrapper.add_child(c)
	self.combo_container.add_child(wrapper)


func add_combo_at_pos(c: Combo, pos: int) -> void:
	self.combo_container.add_child(c)
	self.combo_container.move_child(c, pos)


func remove_combo(c: Combo) -> void:
	self.combo_container.remove_child(c)


func remove_combo_at_pos(pos: int) -> void:
	var c := self.combo_container.get_child(pos)
	self.combo_container.remove_child(c)


func remove_all_combos() -> void:
	for c in self.combos:
		self.combo_container.remove_child(c)
