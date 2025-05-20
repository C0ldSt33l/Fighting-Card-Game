extends Node2D
@onready var Background_totem_panel : Panel = $background_totem_panel
@onready var Background_combo_panel : Panel = $background_combo_panel
@onready var Background_counter_panel : Panel = $background_counter_panel
@onready var counter : Label = $background_counter_panel/Counter
@onready var menu_button :Button = $menu_Button
@onready var RunInfo_button : Button = $RunInfo_Button

var settings_scene = preload("res://main_menu/settings_menu.tscn")
var settings_scene_instance  

var menu_is_open : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_menu_button_pressed()
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_button_pressed() -> void:
	if !menu_is_open:
		menu_is_open = true
		settings_scene_instance = settings_scene.instantiate()
		get_tree().current_scene.add_child(settings_scene_instance)
	else:
		if settings_scene_instance.is_inside_tree():
			menu_is_open = false
		settings_scene_instance.queue_free()
	pass # Replace with function body.
