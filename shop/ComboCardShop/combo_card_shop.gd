extends Node2D
@onready var logger := $Logger as RichTextLabel
@onready var Price = $Panel/Price


var cards = preload("res://card/card.tscn") 


var LabelMoney:Label 
var money : int = 10

var objects :Array[Node2D] = []

var BackgroundPanel : Panel  
var spawn_pos 
var Hide_price_timer: Timer
var rng
var PriceButton:Button
var ChosenCard:Card

func _ready() -> void:
	LabelMoney = get_node("Panel/Label")
	LabelMoney.text = str(money)
	Hide_price_timer = get_node("hide_price_timer")
	PriceButton = get_node("Panel/Button2")	
	Price = get_node("Panel/Button2/Price")
	BackgroundPanel = get_node("Panel")
	
	
	PriceButton.visible = false
	PriceButton.set_size(Price.size)
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	spawn_pos = BackgroundPanel.position + Vector2(10,10)
	var cards = Cards.CARDS.keys().duplicate()
	var n:Vector2
	for i in range(7):
		self.spawn_card(Cards.CARDS[cards[rng.randi_range(0,cards.size() - 1)]], spawn_pos + n)
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
				Price.text = str("price = ",obj.price)
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
	
func spawn_card(config: Dictionary, pos: Vector2) -> void:
	var card := CardFactory.create_with_binding(
		self,
		func (c: Card) -> void:
			c.add_tags(config)
			c.position = pos
	)
	self.objects.append(card)


func _on_button_pressed() -> void:
	if(money>0):
		for object in objects:
			object.queue_free()
		objects.clear()
	
		var cards = Cards.CARDS.keys().duplicate()
		var n:Vector2
		for i in range(7):
			self.spawn_card(Cards.CARDS[cards[rng.randi_range(0,cards.size() - 1)]], spawn_pos + n)
			n.x += 150
		money=money-1
	pass # Replace with function body.

	
func _on_button_2_pressed() -> void:#buy button
	if (money-ChosenCard.price >= 0): 
		PlayerConfig.available_cards.append(ChosenCard)
		money -= ChosenCard.price 
		
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
