extends Control

class_name SkillNode

@onready var name_label: Label = $Background/TextureRect/Name
@onready var description_label: Label = $Background/TextureRect/Description
@onready var panel: Panel = $Background
@onready var port_container: HBoxContainer = $PortContainer
@onready var Price : Label = $Background/TextureRect/Price
@onready var Texture_rect : TextureRect = $Background/TextureRect

@export var name_text: String = "New Node"
@export var description: String = "Description of the node."
@export var icon: Texture2D
@export var Start_node:bool = false


@export var price: int = 0
@export var parent_nodes: Array[SkillNode] = []
@export var child_nodes: Array[SkillNode] = []

@export var unlocked: bool = false

var Meta_func : Callable = func (): pass

func _ready():
	name_label.text = name_text
	description_label.text = description
	Price.text = str(price)
	create_port()

	update_visibility()

func set_unlocked(value: bool):
	if value == unlocked:
		return
	unlocked = value
	update_visibility()

func update_visibility():
	self.visible = unlocked or has_unlocked_parent()
	if child_nodes.size() != null:
		for child in child_nodes:
			child.update_visibility()

func has_unlocked_parent() -> bool:
	if Start_node:
		return true
	for parent in parent_nodes:
		if parent.unlocked:
			return true
	return false

func has_unlocked_children()->bool:
	for child in child_nodes:
		if child.unlocked:
			return true
	return false

func create_port():
	var port = preload("res://Meta/Port/Port.tscn").instantiate()
	port.buy_skill.connect(port_buy_skill)
	port_container.add_child(port)
	return port

func port_buy_skill(port):
	SkillTreeManager.try_upgrade_node(self)


func on_unlocked():
	print("узел куплен")
	panel.modulate = Color.GREEN

func on_locked():
	print("узел закрыт")
	panel.modulate - Color.GRAY
