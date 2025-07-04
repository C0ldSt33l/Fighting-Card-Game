extends Node2D
@onready var Price = $Panel/Button2/Price
@onready var ComboPanel = $Panel/ComboPanel
@onready var ComboPanelLabel: Label = $Panel/ComboPanel/Label
@onready var OpenPackShopButton: Button = $Panel/open_pack_shop
var fullscreen_container: Control

var playerCardID = 1000000

var LabelMoney:Label 
var money : int = 100

var objects :Array = []

var BackgroundPanel : Panel  
var spawn_pos 
var Hide_price_timer: Timer
var rng
var PriceButton:Button	
var ChosenObj
var ALL_cards_with_tags
var All_combo
var All_packs
var count_cards : int = 7

var InfoPanel: Panel

var basket = []
var total_price = 0

func _ready() -> void:
	LabelMoney = get_node("Panel/Label")
	LabelMoney.text = "💲" + str(PlayerConfig.hand_money)
	Hide_price_timer = get_node("hide_price_timer")
	PriceButton = get_node("Panel/Button2")	
	Price = get_node("Panel/Button2/Price")
	BackgroundPanel = get_node("Panel")
	
	if !PlayerConfig.pack_in_shop:
		OpenPackShopButton.hide()
	else:
		OpenPackShopButton.show()
	
	var tmp = []
	tmp = Sql.select_all_type_cards_with_tags('BATTLE')
	ALL_cards_with_tags = tmp
	tmp = Sql.select_all_type_cards_with_tags('UPGRADE')
	ALL_cards_with_tags.append_array(tmp)
	All_combo = Sql.select_all_combos_with_tags()
	
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
	LabelMoney.text ="💲" + str(PlayerConfig.hand_money)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = get_global_mouse_position()
			for obj in objects:
				if obj.Background.get_global_rect().has_point(mouse_pos) and !basket.has(obj):
					obj.modulate = Color.AQUA
					basket.append(obj)
					update_total_price()
					return
				elif obj.Background.get_global_rect().has_point(mouse_pos) and basket.has(obj):
					obj.modulate = Color.GRAY
					basket.erase(obj)
					update_total_price()
					return

func spawn_card(CardInfo: Dictionary, pos:Vector2)-> void:
	var card := CardCreator.create_with_binding(
		self, CardInfo.card['TypeCard'],
		func (c:BaseCard)-> void:
			for i in CardInfo.card:
				if i == 'Body part' and c is BattleCard:
					c.Type = CardInfo.card[i]
				else:
					c[i] = CardInfo.card[i]
			for tag in CardInfo.tags:
				c.tags.append(tag)
			c.position = pos
			
			
			#c.hovered.connect(self.create_panel_with_text)
			#c.unhovered.connect(self.remove_panel)
	)
	self.objects.append(card)
	card.price.show()
	
func spawn_combo(ComboInfo: Dictionary, pos:Vector2)->void:
	var combo:= ComboCreator.create_with_binding(
		self,
		func (c:_Combo_)-> void:
			for i in ComboInfo.combo:
				c[i] = ComboInfo.combo[i]
			
			c.position = pos
	)
	self.objects.append(combo)
	combo.price.show()

func _on_button_pressed() -> void:
	if(money>0):
		for object in objects:
			object.queue_free()
		objects.clear()
		basket.clear()
		update_total_price()
	
		var n:Vector2
		for i in range(7):
			spawn_card(ALL_cards_with_tags[randi() % ALL_cards_with_tags.size()], spawn_pos + Vector2(i * 150, 0))
		arrange_cards()
		spawn_combo(All_combo[randi() % All_combo.size()],Vector2(258,358))
		money=money-1
	pass # Replace with function body.

	
func _on_button_2_pressed() -> void:#buy button
	if (money - total_price >= 0): 
		money -= total_price
		
		var new_object: Array = []
		
		for object in objects:
			if !basket.has(object):
				new_object.append(object)
			else:
				if object is BaseCard:
						PlayerConfig.player_available_cards.append(object.return_all_tags())
				if object is _Combo_:
						PlayerConfig.player_available_combos.append(object.return_all_tags())
				object.queue_free()
		objects = new_object
		print(PlayerConfig.player_available_cards)
		basket.clear()
		total_price = 0
		Save_Manager.auto_save()
				

func update_total_price():
	total_price = 0
	Price.visible = true
	for obj in basket:
		total_price+=obj.Price
	if total_price == 0:
		Price.visible = false
	Price.text = "Total price = %s" % str(total_price)+"💲"

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
	var base_card_size = Vector2(200,300)
	var scale_x = available_width / (base_card_size.x * card_count + total_spacing)
	var scale_y = scale_x 
	var start_position = parent_rect.position.x + 20
	for i in range(card_count):
		var obj = objects[i]
		obj.scale = Vector2(scale_x, scale_y)
		var scaled_width = base_card_size.x * scale_x
		var x_position =start_position + i * (scaled_width + spacing)
		var y_position = (parent_rect.size.y - base_card_size.y * scale_y) / 2
		obj.position = Vector2(x_position, y_position)

func remove_panel():
	if InfoPanel:
		InfoPanel.queue_free()
		InfoPanel = null

func _on_exit_button() -> void:
	SceneManager.__last_scene_type = SceneManager.SCENE.SHOP_ITEMS
	SceneManager.close_current_scene()

func _on_inventory_button() -> void:
	SceneManager.__last_scene_type = SceneManager.SCENE.SHOP_ITEMS
	SceneManager.open_new_scene_by_name(SceneManager.SCENE.INVENTORY)

func _on_pack_shop_button()->void:
	SceneManager.__last_scene_type = SceneManager.SCENE.SHOP_ITEMS
	SceneManager.open_new_scene_by_name(SceneManager.SCENE.SHOP_PACK)
