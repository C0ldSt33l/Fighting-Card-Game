extends Node

# Добавляем сюда все ключевые сцены-окна игры!
enum SCENE {
	MAIN_MENU,
	SETTINGS_MENU,
	META_PROGGRESSION,

	LOADING,

	CHOOSE_ENEMY,
	BATTLE,
	BATTLE_REWORD,

	SHOP_MAIN,
	SHOP_POWER_UPS,
	SHOP_ITEMS,

	INVENTORY,

	RUN_RESULT,
}

var __all_scenes := [
	preload("res://main_menu/main_menu.tscn").instantiate(),
	preload("res://main_menu/settings_menu.tscn").instantiate(),
	#TODO: replace meta-proggression scene
	preload("res://assets/tmp enemy/enemy.jpg"),

	preload("res://loading scene/loading_scene.tscn").instantiate(),

	preload("res://choose enemy/choose_enemy.tscn").instantiate(),
	preload("res://battle/battle_scene.tscn").instantiate(),
	#TODO: replace battle reward scene
	preload("res://assets/tmp enemy/enemy.jpg"),


	preload("res://shop/shop.tscn").instantiate(),
	preload("res://shop/powerUpShop/PowerUpShop.tscn").instantiate(),
	preload("res://shop/ComboCardShop/ComboCardShop.tscn").instantiate(),

	preload("res://Inventory/Inventory.tscn").instantiate(),

	#TODO: replace run result scene
	preload("res://assets/tmp enemy/enemy.jpg"),
]

var __tree_root: Node = null
var __scene_stack: Array[Node] = []
var __last_scene_type: SCENE

func _ready() -> void:
	__tree_root = get_tree().root
	var nodes: Array[Node] = __tree_root.get_children()
	__scene_stack.push_back(nodes.back())
	print_debug("Scene Manager loaded.")
	#print_debug(__scene_stack)
	
func _exit_tree() -> void:
	for scene in __all_scenes:
		queue_free()

func open_new_scene_by_path(scene_path: String) -> void:
	var new_scene = load(scene_path).instantiate()
	__tree_root.remove_child(__scene_stack.back())
	__scene_stack.push_back(new_scene)
	__tree_root.add_child(new_scene)
	
func open_new_scene_by_name(scene_name: SCENE) -> void:
	print_debug("Scene Manager tries to open new scene")
	print_debug(__scene_stack)
	if scene_name < 0 or scene_name >= __all_scenes.size():
		print_debug("Trying to open wrong scene with id #" + str(scene_name))
	var new_scene = __all_scenes[scene_name].duplicate()
	__tree_root.remove_child(__scene_stack.back())
	__scene_stack.push_back(new_scene)
	__tree_root.add_child(new_scene)
	print_debug(__scene_stack)
	print_debug("Scene Manager opened new scene")
	
func close_current_scene() -> void:
	print_debug("Scene Manager got order to close current scene")
	print_debug(__scene_stack)
	call_deferred("__real_closing_scene")
	
func __real_closing_scene() -> void:
	var current_scene = __scene_stack.pop_back() as Node
	__tree_root.remove_child(current_scene)
	#current_scene.queue_free()
	__tree_root.add_child(__scene_stack.back())
	print_debug(__scene_stack)
	print_debug("Scene Manager closed current scene")
