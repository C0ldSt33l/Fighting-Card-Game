extends Node

var SpawnerTotem = preload("res://Control_nodes/Totems/Totem.tscn")
# Called when the node enters the scene tree for the first time.

func create(modifier:Callable)->Totem:
	var totem: Totem
	totem = SpawnerTotem.instantiate() as Totem
	modifier.call(totem)
	return totem

func create_with_binding(parent:Node,modifier:Callable)->Totem:
	var totem:=create(modifier)
	if totem:
		parent.add_child(totem)
	return totem
