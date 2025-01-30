extends Node

var spawner := preload("res://card/card.tscn")


# static func create(
# 	name: String,
# 	type: Card.ACTION_TYPE,
# 	dmg: int,
# 	tags: Dictionary = {}
# ) -> Card:
# 	var card := spawner.instantiate() as Card
# 	card.card_name = name
# 	card.type = type
# 	card.dmg = dmg
# 	card.add_tags(tags)
# 	return card


# static func create_with_binding(
# 	parent: Node,
# 	name: String,
# 	type: Card.ACTION_TYPE,
# 	dmg: int,
# 	tags: Dictionary = {}
# ) -> Card:
# 	var card := create(name, type, dmg, tags)
# 	parent.add_child(card)
# 	return card

## require func with signature `(Card) -> void
func create(modifier: Callable) -> Card:
	var card := spawner.instantiate() as Card
	modifier.call(card)
	return card


## require func with signature `(Card) -> void
func create_with_binding(parent: Node, modifier: Callable) -> Card:
	var card := create(modifier)
	parent.add_child(card)
	return card
	
