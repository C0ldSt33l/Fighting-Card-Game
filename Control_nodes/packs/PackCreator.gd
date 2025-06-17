extends Node

var PackSpawner := preload("res://Control_nodes/packs/Pack.tscn")

func create( modifier:Callable, count_selected_obj : int)->Pack:
	var pack : Pack
	pack.count_selected_obj = count_selected_obj
	pack = PackSpawner.instantiate()
	return pack

func create_with_binding(parent:Node,modifier:Callable,count_selected_obj : int)->Pack:
	var pack : Pack = create(modifier,count_selected_obj)
	if pack:
		parent.add_child(pack)
	return pack
