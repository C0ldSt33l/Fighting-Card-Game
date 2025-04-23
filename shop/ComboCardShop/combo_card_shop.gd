extends Node2D
@onready var Price = $Panel/Price
@onready var ComboPanel = $Panel/ComboPanel
@onready var ComboPanelLabel: Label = $Panel/ComboPanel/Label


var playerCardID = 1000000

var LabelMoney:Label 
var money : int = 10

var objects :Array = []

var BackgroundPanel : Panel  
var spawn_pos 
var Hide_price_timer: Timer
var rng
var PriceButton:Button	
var ChosenObj
var ALL_cards_with_tags
var All_combo
var count_cards : int = 7

var InfoPanel: Panel

func _ready() -> void:
	LabelMoney = get_node("Panel/Label")
	LabelMoney.text = str(money)
	Hide_price_timer = get_node("hide_price_timer")
	PriceButton = get_node("Panel/Button2")	
	Price = get_node("Panel/Button2/Price")
	BackgroundPanel = get_node("Panel")
	
	var tmp = []
	tmp = Sql.select_all_type_cards_with_tags('BATTLE')
	ALL_cards_with_tags = tmp
	tmp = Sql.select_all_type_cards_with_tags('UPGRADE')
	ALL_cards_with_tags.append_array(tmp)
	All_combo = Sql.select_all_combos_with_tags()
	
	for combo in All_combo:
		print(combo)
	
	PriceButton.visible = false
	PriceButton.set_size(Price.size)
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	spawn_pos = BackgroundPanel.position + Vector2(10,10)
	
	var n:Vector2
	for i in range(7):
		spawn_card(ALL_cards_with_tags[randi() % ALL_cards_with_tags.size()], spawn_pos + Vector2(i * 150, 0))
	arrange_cards()
	
	spawn_combo(All_combo[randi() % All_combo.size()],Vector2(258,358))
	
	pass

func _process(delta: float) -> void:
	LabelMoney.text = str(money)
	
	var mouse_pos = get_global_mouse_position()
	var hovered = false
	Hide_price_timer.one_shot = true
	
	for obj in objects:		
		if obj is BaseCard or Combo:
			if obj.Background.get_global_rect().has_point(mouse_pos):
				PriceButton.visible = true
				
				Price.text = "price = %s" % str(obj.Price)
				
				var background_rect = obj.Background.get_global_rect()
				PriceButton.position = background_rect.position + Vector2(-30, background_rect.size.y-60)
				
				hovered = true
				Hide_price_timer.start(0.5)
				ChosenObj = obj
				break
	
	if PriceButton.get_global_rect().has_point(mouse_pos):
		hovered = true
	if not hovered and Hide_price_timer.is_stopped():
		PriceButton.visible = false

func spawn_card(CardInfo: Dictionary, pos:Vector2)-> void:
	var card := CardCreator.create_with_binding(
		self, CardInfo.card['TypeCard'],
		func (c:BaseCard)-> void:
			for i in CardInfo.card:
				if i != 'TypeCard':
					c[i] = CardInfo.card[i]
			#for tag in CardInfo.tags:
				#c.add_tags(tag)
			c.position = pos
			#c.hovered.connect(self.create_panel_with_text)
			#c.unhovered.connect(self.remove_panel)
	)
	self.objects.append(card)
	
func spawn_combo(ComboInfo: Dictionary, pos:Vector2)->void:
	var combo:= ComboCreator.create_with_binding(
		self,
		func (c:Combo)-> void:
			for i in ComboInfo.combo:
				c[i] = ComboInfo.combo[i]
			
			c.position = pos
	)
	self.objects.append(combo)
	

func _on_button_pressed() -> void: #reroll button
	if(money>0):
		for object in objects:
			object.queue_free()
		objects.clear()
	
		var cards = Cards.CARDS.keys().duplicate()
		var n:Vector2
		for i in range(7):
			spawn_card(ALL_cards_with_tags[randi() % ALL_cards_with_tags.size()], spawn_pos + Vector2(i * 150, 0))
		arrange_cards()
		spawn_combo(All_combo[randi() % All_combo.size()],Vector2(258,358))
		money=money-1
	pass # Replace with function body.

	
func _on_button_2_pressed() -> void:#buy button
	if (money - ChosenObj.Price >= 0): 
		money -= ChosenObj.Price 
		
		var new_object :Array = []
		
		for object in objects:
			if object != ChosenObj:
				new_object.append(object)
			else:
				object.queue_free()
				match ChosenObj:
					BaseCard:
						PlayerConfig.player_available_cards.append(ChosenObj.return_all_tags())
					Combo:
						PlayerConfig.player_available_combos.append(ChosenObj.return_all_tags())
		objects = new_object

	pass

func create_panel_with_text(card:BaseCard)->void:
	if InfoPanel:
		InfoPanel.queue_free()
	InfoPanel = Panel.new()
	var label =  Label.new()
	
	label.text = card.Description
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	InfoPanel.add_child(label)
	InfoPanel.position = card.Background.position + Vector2(150,0)
	card.add_child(InfoPanel)

func arrange_cards():
	var parent_rect = $Panel.get_rect()  
	var card_count = count_cards  
	var spacing = 10

	var total_spacing = spacing * (card_count - 1)
	var available_width = parent_rect.size.x - total_spacing

	var base_card_size = objects[1].Background.size  

	var scale_x = available_width / (base_card_size.x * card_count + total_spacing)
	var scale_y = scale_x 
	
	var start_position = parent_rect.position.x + 20

	for i in range(card_count):
		var obj = objects[i]
		if obj is BaseCard:
			
			obj.scale = Vector2(scale_x, scale_y)

			var scaled_width = base_card_size.x * scale_x
			var x_position =start_position + i * (scaled_width + spacing)
			var y_position = (parent_rect.size.y - base_card_size.y * scale_y) / 2  # Центрируем по вертикали

			obj.position = Vector2(x_position, y_position)

func remove_panel():
	if InfoPanel:
		InfoPanel.queue_free()
		InfoPanel = null
