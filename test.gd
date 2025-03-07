extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vec = Vector2(10,10)
	var n:Vector2
	var ALL_BATTLE_CARDS = Sql.select_all_type_cards_with_tags('BATTLE')
	for i in ALL_BATTLE_CARDS:
		print(i)
		
		spawn_card(i,vec + n)
		n.x += 150
	print()
	
	var all_upgrade_cards = Sql.select_all_type_cards_with_tags('UPGRADE')
	for i in all_upgrade_cards:
		print(i)
	print()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_card(CardInfo: Dictionary, pos:Vector2)-> void:
	for i in CardInfo.card:
		print(i)
		
	var card := CardCreator.create_with_binding(
		self, CardInfo.card['TypeCard'],
		func (c:_Card_)-> void:
			for i in CardInfo.card:
				if i != 'TypeCard':
					c[i] = CardInfo.card[i]
			#for tag in CardInfo.tags:
				#c.add_tags(tag)
			c.position = pos
	)
