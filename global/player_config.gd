extends Node


var upgrade_money: int
var hand_money: int

var player_available_combos: Array
var player_available_cards: Array
var player_available_totems: Array

var deck_cards: Array[_Card_]
var cards_in_hand: Array[_Card_] # for what it need?
var hand_size: int = 5

var player_power: int

var enemy_data: EnemyData = null