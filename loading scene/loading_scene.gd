extends Control

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	self.switch_to_next_scene(SceneManager.__last_scene_type)


func switch_to_next_scene(scene_type: SceneManager.SCENE) -> void:
	const S := SceneManager.SCENE
	SceneManager.__last_scene_type = S.LOADING 
	var next_scene: S
	match scene_type:
		S.CHOOSE_ENEMY:
			next_scene = S.BATTLE
			pass
		S.BATTLE:
			next_scene = S.BATTLE_REWORD
			pass
		S.BATTLE_REWORD:
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
			push_error('Wrong scene type with id#%s' % [scene_type])

	# NOTE: next scen wont open
	# SceneManager.call_deferred('close_current_scene')

	SceneManager.call_deferred('open_new_scene_by_name', next_scene)
