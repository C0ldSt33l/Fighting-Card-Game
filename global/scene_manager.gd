extends Node

# Добавляем сюда все ключевые сцены-окна игры!
enum SCENE {
	MAIN_MENU,
	SETTINGS_MENU,
	META_PROGGRESSION,

	LOADING,

	CHOOSE_ENEMY,
	BATTLE,
	BATTLE_REWARD,

	SHOP_MAIN,
	SHOP_POWER_UPS,
	SHOP_ITEMS,
	SHOP_PACK,

	INVENTORY,

	RUN_RESULT,
}

var __all_scenes := {
		SCENE.MAIN_MENU:        preload("res://main_menu/main_menu.tscn").instantiate(),
		SCENE.SETTINGS_MENU:    preload("res://main_menu/settings_menu.tscn").instantiate(),
		SCENE.META_PROGGRESSION:preload("res://Meta/Meta.tscn").instantiate(),
 
		SCENE.LOADING:          preload("res://loading scene/loading_scene.tscn").instantiate(),

		SCENE.CHOOSE_ENEMY:     preload("res://choose enemy/choose_enemy.tscn").instantiate(),
		SCENE.BATTLE:           preload("res://battle/battle_scene.tscn").instantiate(),
		SCENE.BATTLE_REWARD:    preload("res://Control_nodes/battle reward/battle_revard.tscn").instantiate(),

		SCENE.SHOP_MAIN:        preload("res://shop/shop.tscn").instantiate(),
		SCENE.SHOP_POWER_UPS:   preload("res://shop/powerUpShop/PowerUpShop.tscn").instantiate(),
		SCENE.SHOP_ITEMS:       preload("res://shop/ComboCardShop/ComboCardShop.tscn").instantiate(),
		SCENE.SHOP_PACK:        preload("res://shop/ComboCardShop/PackShop/PackShop.tscn").instantiate(),

		SCENE.INVENTORY:        preload("res://Inventory/Inventory.tscn").instantiate(),

		#TODO: replace run result scene
		 SCENE.RUN_RESULT:      preload("res://run result/run_result.tscn").instantiate(),
	
}

var __tree_root: Node = null
var __scene_stack: Array[Node] = []
var __last_scene_type: SCENE


func get_scene_name(s: SCENE) -> String:
	return SCENE.keys()[s]

func _ready() -> void:
	__tree_root = get_tree().root
	var nodes: Array[Node] = __tree_root.get_children()
	__scene_stack.push_back(nodes.back())
	print('Scene stack at game run:\n', self.__scene_stack)
	
func _exit_tree() -> void:
	for scene in __all_scenes:
		queue_free()

func open_new_scene_by_path(scene_path: String) -> void:
	var new_scene = load(scene_path).instantiate()
	__tree_root.remove_child(__scene_stack.back())
	__scene_stack.push_back(new_scene)
	__tree_root.add_child(new_scene)
	
func open_new_scene_by_name(scene_name: SCENE) -> void:
	if scene_name < 0 or scene_name >= __all_scenes.size():
		print_debug("Trying to open wrong scene with id #" + str(scene_name))
	var new_scene = __all_scenes[scene_name].duplicate()
	__tree_root.remove_child(__scene_stack.back())
	__scene_stack.push_back(new_scene)
	__tree_root.add_child(new_scene)

	print('Scene stack after adding new scene: ', self.get_scene_name(scene_name))
	print(self.__scene_stack)
	
func close_current_scene() -> void:
	call_deferred("__real_closing_scene")
	
func __real_closing_scene() -> void:
	var current_scene = __scene_stack.pop_back() as Node
	__tree_root.remove_child(current_scene)
	current_scene.queue_free()
	__tree_root.add_child(__scene_stack.back())
	print("Scene Manager after deleting cur scene: ", self.get_scene_name(self.__last_scene_type))
	print(__scene_stack)
