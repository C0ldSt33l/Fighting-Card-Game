extends Node2D

@onready var scrollContainer = $Panel/ScrollContainer
@onready var gridContainer = $Panel/ScrollContainer/GridContainer



@export var card_per_row : int = 4

var selected_object = null
var is_sell_popup_active = false
#tmp
var tmp
var ALL_cards_with_tags



# Called when the node enters the scene tree for the first time.
func _ready() -> void:  # Явно задаем размер
	scrollContainer.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
	gridContainer.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
	
	gridContainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	gridContainer.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	tmp = Sql.select_all_type_cards_with_tags('BATTLE')
	ALL_cards_with_tags = tmp
	tmp = Sql.select_all_type_cards_with_tags('UPGRADE')
	ALL_cards_with_tags.append_array(tmp)
	
	gridContainer.columns = card_per_row
	upgradeInventory()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var mouse_pos = get_global_mouse_position()
			
			for obj in gridContainer.get_children():
				if obj.Background.get_global_rect().has_point(mouse_pos):
					
					if selected_object == obj:
						return
					# Если активно другое окно продажи, закрываем его
					if is_sell_popup_active:
						clear_sell_popup()
					
					show_sell_popup(obj, mouse_pos)
					break

func upgradeInventory():
	for child in gridContainer.get_children():
		child.queue_free()
	
	for child_data in ALL_cards_with_tags:
		var card = create_card(child_data)
		gridContainer.add_child(card)
		print("Card added:", card.name)  # Отладочный вывод
	arrange_cards()
	var n =0
	print(gridContainer.get_child_count())

func arrange_cards():
	var parent_rect = gridContainer.get_rect()
	var card_count = ALL_cards_with_tags.size()
	var columns = gridContainer.columns
	var rows = ceil(card_count / float(columns))
	
	var available_width = parent_rect.size.x / columns
	var available_height = parent_rect.size.y / rows
	
	var base_card_size = Vector2(200, 300)
	
	var scale_x = available_width / base_card_size.x
	var scale_y = available_height / base_card_size.y
	var scale = min(scale_x, scale_y)
	
	for child in gridContainer.get_children():
		if child is BaseCard:
			child.scale = Vector2(scale, scale)
	
func create_card(CardInfo: Dictionary)-> BaseCard:
	var card := CardCreator.create(CardInfo.card['TypeCard'],
		func (c:BaseCard)-> void:
			for i in CardInfo.card:
				c[i] = CardInfo.card[i]
			for i in CardInfo.tags:
				c.tags.append(i)
	)
	card.scale = Vector2(0.66,0.66)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
	return card

func create_combo(ComboInfo: Dictionary)->_Combo_:
	var combo = ComboCreator.create(
		func (c:_Combo_)-> void:
			for i in ComboInfo:
				c[i] = ComboInfo[i] 
	)
	combo.size_flags_horizontal =  Control.SIZE_EXPAND_FILL
	combo.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return combo

func _on_cards_pressed() -> void:
	gridContainer.columns = 4
	for child in gridContainer.get_children():
		gridContainer.remove_child(child)
		child.queue_free()
	
	for child_data in PlayerConfig.player_available_cards:
		var card = create_card(child_data)
		gridContainer.add_child(card)
		print("Card added:", card.name) 
	print(gridContainer.get_child_count()) # Отладочный вывод
	arrange_cards()
	pass 

func show_sell_popup(obj,Position: Vector2):
	var sell_popup_scene = preload("res://Inventory/SellPopup/SellPopup.tscn")
	var sell_popup = sell_popup_scene.instantiate()
	
	add_child(sell_popup)
	
	sell_popup.position = Position
	
	var label = sell_popup.get_node("Panel/Label")
	var yes_button = sell_popup.get_node("Panel/Yes")
	var no_button = sell_popup.get_node("Panel/No")
	
	label.text = "Продать за %s?" % str(obj.Price)
	selected_object = obj
	
	yes_button.pressed.connect(on_yes_pressed)
	no_button.pressed.connect(on_no_pressed)
	is_sell_popup_active = true
	
func on_yes_pressed():
	if selected_object:
		gridContainer.remove_child(selected_object)
		
		selected_object.queue_free()
		#нужно добавить удаление объекта из файла игрока 
		var money : int  = 0 
		money += selected_object.Price	
		print("Sold for:", selected_object.Price)
	clear_sell_popup()
	
func on_no_pressed():
	clear_sell_popup()
	
func clear_sell_popup():
	if has_node("SellPopup"):
		var obj = $SellPopup
		self.remove_child(obj)
		#obj.queue_free()
		
	selected_object = null
	is_sell_popup_active = false
	
func _on_combos_pressed() -> void:
	for child in gridContainer.get_children():
		child.queue_free()
		
	gridContainer.columns = 1
	for child_data in PlayerConfig.player_available_combos:
		var combo = create_combo(child_data)
		gridContainer.add_child(combo)
		print("_Combo_ added:", combo.name)
	pass # Replace with function body.



func _on_totem_pressed() -> void:
	print("not worked now")
	pass # Replace with function body.
