extends Control
class_name RunResult
@onready var meta_lbl: Label = $"Panel/meta lbl"
@onready var victory_lbl: Label = $"Panel/victory lbl"
@onready var monster_lbl: Label = $"Panel/monster lbl"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.victory_lbl.text = 'ПОБЕДА' if PlayerConfig.player_won else 'ПОРАЖЕНИЕ'
	self.meta_lbl.text += str(PlayerConfig.upgrade_money_in_battle)
	self.monster_lbl.text += str(PlayerConfig.defeated_monster_count)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	SceneManager.__last_scene_type = SceneManager.SCENE.RUN_RESULT
	SceneManager.close_current_scene()
