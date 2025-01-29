class_name CardFactory
static var spawner := preload("res://card/card.tscn")


static func create(tags: Dictionary) -> Card:
	var card := spawner.instantiate() as Card
	card.add_tags(tags)
	return card


static func create_with_binding(tags: Dictionary, parent: Node) -> Card:
	var card := create(tags)
	parent.add_child(card)
	return card
