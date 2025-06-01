extends Control
class_name ComboSeqment

@onready var combo_container: VBoxContainer = $"Background/MarginContainer/Combo Container"
var combos: Array[Combo] :
	get():
		var a: Array[Combo]
		a.assign(self.combo_container.get_children())
		return a

#TODO: handle drag n drop
func _ready() -> void:
	#self.combo_container.remove_child(
		#self.combo_container.get_child(0)
	#)
	pass

func add_combo(c: Combo) -> void:
	self.combo_container.add_child(c)


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
