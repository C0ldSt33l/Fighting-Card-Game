extends Node2D
@onready var logger := $Logger as RichTextLabel

var cards = preload("res://card/card.tscn") 
var AllCards = preload("res://global/cards.gd")
var AllCombos = preload("res://global/combos.gd")

var objects :Array[Node2D] = []

var BackgroundPanel : Panel  
var spawn_pos 

var rng

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	BackgroundPanel = get_node("Panel")
	spawn_pos = BackgroundPanel.position + Vector2(10,10)
	
	var cards = AllCards.CARDS.keys().duplicate()
	var n:Vector2
	for i in range(7):
		self.spawn_card(AllCards.CARDS[cards[rng.randi_range(0,cards.size() - 1)]], spawn_pos + n)
		n.x += 150

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_card(config: Dictionary, pos: Vector2) -> void:
	var card := CardFactory.create_with_binding(
		self,
		func (c: Card) -> void:
			c.add_tags(config)
			c.position = pos
	)
	self.objects.append(card)


func _on_button_pressed() -> void:
	for object in objects:
		object.queue_free()
	objects.clear()
	
	var cards = AllCards.CARDS.keys().duplicate()
	var n:Vector2
	for i in range(7):
		self.spawn_card(AllCards.CARDS[cards[rng.randi_range(0,cards.size() - 1)]], spawn_pos + n)
		n.x += 150
	
	pass # Replace with function body.
