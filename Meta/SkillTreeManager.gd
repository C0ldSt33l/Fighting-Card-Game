extends Control

@export var nodes: Array[SkillNode] = []


func _ready():
	Events.skill_tree_scene_opened.connect(try_take_tree)
	Events.skill_tree_scene_closed.connect(get_all_nodes_save_data)
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
	if PlayerConfig.upgrade_money >= node.price and (node.has_unlocked_parent() or node.is_start_node):
		PlayerConfig.upgrade_money -= node.price
		unlock_node(node)
		node.on_unlocked()
		print("Узел разблокирован! Осталось денег: ", PlayerConfig.upgrade_money)
			
func try_to_lock(node: SkillNode):
		PlayerConfig.upgrade_money += node.price
		lock_node(node)
		node.on_locked()

func try_take_tree(StartNode : SkillNode):
	_collect_nodes_recursive(StartNode, nodes)
	Save_Manager.load_game_meta()
	load_skill_tree(Save_Manager.nodes)
	pass

func _collect_nodes_recursive(current_node: SkillNode, collected_nodes: Array) -> void:
	if current_node in collected_nodes:  
		return
	collected_nodes.append(current_node)
	for child in current_node.child_nodes:
		_collect_nodes_recursive(child, collected_nodes)


func get_all_nodes_save_data() -> void:
	var save_data = []
	for node in nodes:
		if !Save_Manager.nodes.has(node):
			save_data.append(node.get_save_data())
	Save_Manager.nodes.append_array(save_data)  
	print(Save_Manager.nodes)
	Save_Manager.save_game_meta()

func load_skill_tree(data: Array):
	if data != null:
		for node_data in data:
			for node in nodes:
				node.load_save_data(node_data)
