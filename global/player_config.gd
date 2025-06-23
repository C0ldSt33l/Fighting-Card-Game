extends Node

@onready var timer : Timer

var total_time_in_secs : int = 0

var upgrade_money: int
var hand_money: int = 100
var battle_money: int

var player_available_combos: Array
var player_available_cards: Array
var player_available_totems: Array

var deck_cards: Array[_Card_]
var cards_in_hand: Array[_Card_] # for what it need?
var hand_size: int = 10

var player_power: int
var battle_reroll_count : int

var main_round_count: int = 3
var count_of_extra_rounds : int = 0
var round_count: int :
	get(): return self.main_round_count + self.count_of_extra_rounds

var extra_damage : int
var extra_points_to_combo : int
var pack_in_shop : bool = false

var main_reroll_count: int = 2
var extra_reroll_count: int = 0
var reroll_count: int :
	get(): return self.main_reroll_count + self.extra_reroll_count

var enemy_data: EnemyData = null

var can_upgrade : bool 


var defeated_monster_count: int = 0
var max_defedated_monster_count: int = 2

var player_won: bool = true 

func _ready() -> void:
	pass
