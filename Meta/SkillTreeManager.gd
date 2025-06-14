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

func try_unlock_node(node: SkillNode):
	# Проверяем, можно ли разблокировать узел (достаточно денег и есть разблокированный родитель)
	if money >= node.price and (node.has_unlocked_parent() or node.is_start_node):
		money -= node.price
		unlock_node(node)
		node.on_unlocked()
		print("Узел разблокирован! Осталось денег: ", money)
