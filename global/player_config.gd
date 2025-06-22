extends Node

@onready var timer : Timer

var total_time_in_secs : int = 0

var upgrade_money: int
var hand_money: int = 100

var player_available_combos: Array
var player_available_cards: Array
var player_available_totems: Array

var deck_cards: Array[_Card_]
var cards_in_hand: Array[_Card_] # for what it need?
var hand_size: int = 10

var player_power: int
var battle_reroll_count : int
var count_of_extra_rounds : int
var extra_damage : int
var extra_points_to_combo : int
var pack_in_shop : bool = false

var enemy_data: EnemyData = null

var can_upgrade : bool 

func _ready() -> void:
	pass
