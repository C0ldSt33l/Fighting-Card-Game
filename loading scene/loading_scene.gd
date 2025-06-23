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
			var pc := PlayerConfig
			if !pc.player_won or pc.defeated_monster_count == pc.max_defedated_monster_count:
				next_scene = S.RUN_RESULT
			else:
				next_scene = S.BATTLE_REWARD
		S.BATTLE_REWARD:
			next_scene = S.SHOP_ITEMS

		S.SHOP_ITEMS:
			next_scene = S.CHOOSE_ENEMY

		S.RUN_RESULT:
			SceneManager.close_current_scene()
		_:
			push_error('Wrong scene type with id#%s-%s' % [scene_type, SceneManager.SCENE.keys()[scene_type]])

	# NOTE: next scen wont open
	# SceneManager.call_deferred('close_current_scene')

	SceneManager.call_deferred('open_new_scene_by_name', next_scene)
