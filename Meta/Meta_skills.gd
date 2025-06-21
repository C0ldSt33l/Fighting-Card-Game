extends Node

class_name MetaSkills

static func upgrade_reroll_count(n: int = 1):
	PlayerConfig.battle_reroll_count+=n
	print("upgrade_reroll_count")

static func add_extra_round(n: int = 1):
	PlayerConfig.count_of_extra_rounds+=n
	print("upgrade_extra_round")
	
static func add_extra_damage(n: int = 1):
	PlayerConfig.extra_damage+=n
	
static func add_more_points_to_combo(n : int = 11):
	PlayerConfig.extra_points_to_combo+=n

static func pack_in_shop():
	PlayerConfig.pack_in_shop = true
