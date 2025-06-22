extends Control
class_name Enemy

@onready var texture_rect: TextureRect = $TextureRect
@onready var enemy_health: EnemyHealth = $"Enemy health"
@onready var enemy_info: EnemyInfo = $"Enemy info"

var health: int = -1 :
	set = set_health
var enemy_name: String = 'Nobody' :
	set = set_enemy_name
var constraints: String = 'Empty':
	set = set_constraints
var max_round_count: int = -1
var rest_round_count: int = -1 :
	set = set_round_count


func set_health(hp: int) -> void:
	health = hp
	self.enemy_health.health_lbl.text = str(hp)

func set_enemy_name(name: String) -> void:
	enemy_name = name.capitalize()
	self.enemy_info.name_lbl.text = enemy_name
	
func set_constraints(constraint: String) -> void:
	constraints = constraint.capitalize()
	self.enemy_info.constrains_lbl.text = 'Ограничения:\n%s' % constraints
	
func set_round_count(rest_round: int) -> void:
	rest_round_count = rest_round
	self.enemy_info.round_count_lbl.text = 'Раундов: %s//%s' % [rest_round, self.max_round_count]
	
