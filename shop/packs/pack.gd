extends Node2D

var generateable = []
var count_of_types_pack:int
var rnd
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rnd = RandomNumberGenerator.new()
	
	count_of_types_pack = Sql.select_count_of_records('PACK')
	generateable = Sql.select_objects_in_pack_by_id(rnd.randf_range(0,count_of_types_pack))
	var tmp = []
	for object in generateable:
		match object['Object_type']:
			'BATTLE':
				for i in range(object['Count']):
					tmp.append(Sql.select_battle_card_dy_id(object['id_object']))
			'UPGRADE':
				for i in range(object['Count']):
					tmp.append(Sql.select_upgrade_card_dy_id(object['id_object']))
			'CONSUMABLE':
				for i in range(object['Count']):
					tmp.append(Sql.select_consumable_card_dy_id(object['id_object']))
			'COMBO':
				for i in range(object['Count']):
					tmp.append(Sql.select_combo_by_id(object['id_object']))
			'TOTEM':
				for i in range(object['Count']):
					tmp.append(Sql.select_combo_by_id(object['id_object']))
					
	var result = []
	for i in range(10):
		result.append(rnd.randf_range(0,tmp.size()))


func _process(delta: float) -> void:
	pass
