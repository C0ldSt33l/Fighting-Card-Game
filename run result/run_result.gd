extends Control
class_name RunResult


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	SceneManager.__last_scene_type = SceneManager.SCENE.RUN_RESULT
	SceneManager.close_current_scene()
