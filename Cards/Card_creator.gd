extends Node

var spawner_battle_card :=preload("res://Cards/Battle_cards/Battle_card.tscn")
var spawner_upgrade_card := preload("res://Cards/Upgrade_cards/Upgrade_card.tscn")
var spawner_consumable_card :=preload("res://Cards/Consumable_cards/Consumable_card.tscn")

func create(card_type:String, modifier:Callable)->_Card_:
	var card: _Card_
	
	match card_type:
		"BATTLE":
			card = spawner_battle_card.instantiate() as _Card_
		"UPGRADE":
			card = spawner_upgrade_card.instantiate() as _Card_
		"CONSUMABLE":
			card = spawner_consumable_card.instantiate() as _Card_
		_:
			push_error("Unknown card type: ", card_type)
			return null
	modifier.call(card)
	return card
	
func create_with_binding(parent:Node,card_type:String,modifier:Callable)->_Card_:
	var card:=create(card_type,modifier)
	if card:
		parent.add_child(card)
	return card
