extends Control
class_name LoadingScene


func _enter_tree() -> void:
	await get_tree().create_timer(0.5).timeout
	self.switch_to_next_scene(SceneManager.__last_scene_type)


func switch_to_next_scene(scene_type: SceneManager.SCENE) -> void:
	const S := SceneManager.SCENE
	SceneManager.__last_scene_type = S.LOADING 
	var next_scene: S
	match scene_type:
		S.MAIN_MENU:
			next_scene = S.CHOOSE_ENEMY

		S.CHOOSE_ENEMY:
			next_scene = S.BATTLE
		S.BATTLE:
			next_scene = S.BATTLE_REWARD
		S.BATTLE_REWARD:
			pass

		S.SHOP_MAIN:
			pass
		S.SHOP_POWER_UPS:
			pass
		S.SHOP_ITEMS:
			pass

		S.INVENTORY:
			pass	

		S.RUN_RESULT:
			pass
		_:
			push_error('Wrong scene type with id#%s-%s' % [scene_type, SceneManager.SCENE.keys()[scene_type]])

	# NOTE: next scen wont open
	# SceneManager.call_deferred('close_current_scene')

	SceneManager.call_deferred('open_new_scene_by_name', next_scene)
