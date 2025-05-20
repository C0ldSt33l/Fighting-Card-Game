extends Control


@onready var main_menu := $VBoxContainer as VBoxContainer
@onready var settins_menu := $Settings as SettingsMenu

@onready var music := $Music as AudioStreamPlayer
@onready var sound_effect := $SoundEffect as AudioStreamPlayer


func _on_start_pressed() -> void:
	print('Game is started')
	

func _on_exit_pressed() -> void:
	get_tree().quit()


func _swap_menu() -> void:
	self.main_menu.visible = !self.main_menu.visible
	self.settins_menu.visible = !self.settins_menu.visible
