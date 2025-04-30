extends Node


const spawner := preload("res://battle/card/card.tscn")


## require func with signature `(Card) -> void`
func create(modifier: Callable) -> Card:
	var card := spawner.instantiate() as Card
	modifier.call(card)
	return card


## require func with signature `(Card) -> void`
func create_with_binding(parent: Node, modifier: Callable) -> Card:
	var card := create(modifier)
	parent.add_child(card)
	return card
