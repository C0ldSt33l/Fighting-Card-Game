extends Node2D
@onready var StartNode : SkillNode = $StartNode
signal scene_is_open
signal scene_is_close
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.skill_tree_scene_opened.emit(StartNode)
	print("signal is emit with Start node = ",StartNode.name_text)
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _enter_tree() -> void:
	Events.skill_tree_scene_opened.emit(StartNode)
	
func _exit_tree() -> void:
	Events.skill_tree_scene_closed.emit() 


func _on_button_pressed() -> void:
	Events.skill_tree_scene_closed.emit()
	SceneManager.__last_scene_type = SceneManager.SCENE.META_PROGGRESSION
	SceneManager.close_current_scene()
	pass # Replace with function body.
