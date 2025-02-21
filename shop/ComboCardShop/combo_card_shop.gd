extends Node2D
@onready var logger := $Logger as RichTextLabel
@onready var Price = $Panel/Price


var cards = preload("res://card/card.tscn") 

var playerCardID = 1000000

var LabelMoney:Label 
var money : int = 10

var objects :Array[Node2D] = []

var BackgroundPanel : Panel  
var spawn_pos 
var Hide_price_timer: Timer
var rng
var PriceButton:Button
var ChosenCard:Card
var ALL_cards_with_tags
func _ready() -> void:
	LabelMoney = get_node("Panel/Label")
	LabelMoney.text = str(money)
	Hide_price_timer = get_node("hide_price_timer")
	PriceButton = get_node("Panel/Button2")	
	Price = get_node("Panel/Button2/Price")
	BackgroundPanel = get_node("Panel")
	
	ALL_cards_with_tags = Sql.select_cards_with_tags()
	#print(ALL_cards_with_tags)
	print("-------config cards--------")
	for cardName in ALL_cards_with_tags:
		print(cardName.card)
		print(cardName.tags)
	print("-------config cards--------")
	print()
	print("-------Players cards--------")
	var ALL_player_card = Sql.select_players_cards()
	for CardName in ALL_player_card:
		print(CardName.card)
		print(CardName.tags)
		print()
	print("-------Players cards--------")
	
		 
	
	PriceButton.visible = false
	PriceButton.set_size(Price.size)
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	spawn_pos = BackgroundPanel.position + Vector2(10,10)
	
	var n:Vector2
	for i in range(7):
		self.spawn_card(ALL_cards_with_tags[rng.randf_range(0,3)], spawn_pos + n)
		n.x += 150



func _process(delta: float) -> void:
	LabelMoney.text = str(money)
	
	var mouse_pos = get_global_mouse_position()
	var hovered = false
	Hide_price_timer.one_shot = true
	for obj in objects:		
		if obj is Card:
			if obj.Background.get_global_rect().has_point(mouse_pos):
				PriceButton.visible = true
				Price.text = str("price = ",obj.Price)
				PriceButton.position = obj.Background.global_position + Vector2(-30, 100)
				hovered = true
				
				Hide_price_timer.start(0.5)
				ChosenCard = obj
				break
	if PriceButton.get_global_rect().has_point(mouse_pos):
		hovered = true
				
	if PriceButton.get_global_rect().has_point(mouse_pos):
		hovered = true
		
	if not hovered and Hide_price_timer.is_stopped():
		PriceButton.visible = false
	
	
	
#func spawn_card(config: Dictionary, pos: Vector2) -> void:
	#var card := CardFactory.create_with_binding(
		#self,
		#func (c: Card) -> void:
			#c.add_tags(config)
			#c.position = pos
	#)
	#self.objects.append(card)

func spawn_card(CardInfo: Dictionary, pos:Vector2)-> void:
	var card := CardFactory.create_with_binding(
		self,
		func (c:Card)-> void:
			for i in CardInfo.card:
				c[i] = CardInfo.card[i]
			#for tag in CardInfo.tags:
				#c.add_tags(tag)
			c.position = pos
	)
	self.objects.append(card)

func _on_button_pressed() -> void: #reroll button
	if(money>0):
		for object in objects:
			object.queue_free()
		objects.clear()
	
		var cards = Cards.CARDS.keys().duplicate()
		var n:Vector2
		for i in range(7):
			self.spawn_card(ALL_cards_with_tags[rng.randf_range(0,3)], spawn_pos + n)
			n.x += 150
		money=money-1
	pass # Replace with function body.

	
func _on_button_2_pressed() -> void:#buy button
	if (money-ChosenCard.Price >= 0): 
		Sql.insert_card_to_playerCollection(playerCardID,ChosenCard.id)
		Sql.insert_tag_to_card(playerCardID,10)
		playerCardID+=1
		money -= ChosenCard.Price 
		
		var new_object :Array[Node2D] = []
		
		for object in objects:
			if object is Card:
				if object != ChosenCard:
					new_object.append(object)
				else:
					object.queue_free()
					
		objects = new_object
		print(PlayerConfig.available_cards.size())
	pass # Replace with function body.
