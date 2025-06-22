extends Node

var spawner_combo = preload("res://Control_nodes/Combo/Combo.tscn")
# Called when the node enters the scene tree for the first time.
func create(modifier:Callable)->_Combo_:
	var combo: _Combo_
	combo = spawner_combo.instantiate() as _Combo_
	modifier.call(combo)
	return combo

func create_with_binding(parent:Node,modifier:Callable)->_Combo_:
	var combo:=create(modifier)
	if combo:
		parent.add_child(combo)
	return combo
	
