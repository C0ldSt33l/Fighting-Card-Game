extends Node

var PackSpawner := preload("res://Control_nodes/packs/Pack.tscn")

func create( modifier:Callable, count_selected_obj : int, can_open : bool)->Pack:
	var pack : Pack
	pack = PackSpawner.instantiate()
	pack.count_selected_obj = count_selected_obj
	pack.can_open = can_open
	modifier.call(pack)
	return pack

func create_with_binding(parent:Node, modifier:Callable ,count_selected_obj : int, can_open : bool)->Pack:
	var pack : Pack = create(modifier,count_selected_obj, can_open)
	if pack:
		parent.add_child(pack)
	return pack
