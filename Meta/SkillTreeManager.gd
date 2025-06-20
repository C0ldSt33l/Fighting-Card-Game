extends Control

@export var start_node: SkillNode
@export var nodes: Array[SkillNode] = []
var money: int = 1000

func _ready():
	if start_node:
		start_node.is_start_node = true
		unlock_node(start_node)

# Для ручного разблокирования
func unlock_node(node: SkillNode):
	node.unlocked = true
	for child in node.child_nodes:
		child.update_visibility()

func lock_node(node: SkillNode):
	node.unlocked = false
	for child in node.child_nodes:
		child.update_visibility()

func try_upgrade_node(node: SkillNode):
	if node.unlocked:
		try_to_lock(node)
	else:
		try_unlock_node(node)

func try_unlock_node(node: SkillNode):
	if money >= node.price and (node.has_unlocked_parent() or node.is_start_node):
		money -= node.price
		unlock_node(node)
		node.on_unlocked()
		print("Узел разблокирован! Осталось денег: ", money)
			
func try_to_lock(node: SkillNode):
		money += node.price
		lock_node(node)
		node.on_locked()
