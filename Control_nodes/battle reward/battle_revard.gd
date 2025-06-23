extends Control
@onready var MoneyLabel : Label = $Panel/Money
 
func _ready() -> void:
	var packinfo = Sql.select_pack_by_id(1)
	spawn_pack(packinfo[0],Vector2(100,133))
	MoneyLabel.text = "За бой получено "
	
func _process(delta: float) -> void:
	if !self.has_node("Pack"):
		SceneManager.__last_scene_type = SceneManager.SCENE.BATTLE_REWARD
		SceneManager.close_current_scene()
	pass

func spawn_pack(PackInfo : Dictionary, pos: Vector2)-> void: 
	var pack:= PackCreator.create_with_binding(
		self,
		func (p:Pack)-> void:
			for i in PackInfo:
				p[i] = PackInfo[i]
			,
			3, true
	)
	pack.position = pos
