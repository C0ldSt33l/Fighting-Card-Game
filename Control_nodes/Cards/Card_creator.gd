extends Control

var spawner_battle_card :=preload("res://Control_nodes/Cards/BattleCards/BattleCard.tscn")
var spawner_upgrade_card := preload("res://Control_nodes/Cards/UpgradeCards/UpgradeCard.tscn")
var spawner_consumable_card :=preload("res://Control_nodes/Cards/ConsumableCards/ConsumableCard.tscn")

func create(card_type:String, modifier:Callable)->BaseCard:
	var card: BaseCard
	
	match card_type:
		"BATTLE":
			card = spawner_battle_card.instantiate() as BaseCard
		"UPGRADE":
			card = spawner_upgrade_card.instantiate() as BaseCard
		"CONSUMABLE":
			card = spawner_consumable_card.instantiate() as BaseCard
		_:
			push_error("Unknown card type: ", card_type)
			return null
	modifier.call(card)
	return card
	
func create_with_binding(parent:Node,card_type:String,modifier:Callable)->BaseCard:
	var card:=create(card_type,modifier)
	if card:
		parent.add_child(card)
	return card
