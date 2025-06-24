extends Control
class_name MainMenu


@onready var main_menu := $VBoxContainer as VBoxContainer
@onready var settins_menu := $Settings as SettingsMenu

@onready var music := $Music as AudioStreamPlayer
@onready var sound_effect := $SoundEffect as AudioStreamPlayer


func _on_start_pressed() -> void:
	PlayerConfig.player_exit = false
	SceneManager.__last_scene_type = SceneManager.SCENE.MAIN_MENU
	SceneManager.call_deferred('open_new_scene_by_name', SceneManager.SCENE.LOADING)
	

func _on_exit_pressed() -> void:
	get_tree().quit()


func _swap_menu() -> void:
	self.main_menu.visible = !self.main_menu.visible
	self.settins_menu.visible = !self.settins_menu.visible

func _on_meta_pressed() ->void:
	SceneManager.__last_scene_type = SceneManager.SCENE.MAIN_MENU
	SceneManager.call_deferred("open_new_scene_by_name",SceneManager.SCENE.META_PROGGRESSION)
