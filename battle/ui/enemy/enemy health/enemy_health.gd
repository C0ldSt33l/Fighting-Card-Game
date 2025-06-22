extends Control
class_name EnemyHealth

@onready var background: Panel = $background
@onready var health_lbl: Label = $"background/health lbl"

func set_health_text(health: int) -> void:
	self.health_lbl.text = '1 000' if health == 1000 else str(health)
