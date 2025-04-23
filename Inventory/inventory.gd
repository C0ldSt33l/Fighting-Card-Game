extends Node2D

@onready var scrollContainer = $Panel/ScrollContainer
@onready var gridContainer = $Panel/ScrollContainer/GridContainer

@export var card_per_row : int = 4

#tmp
var tmp
var ALL_cards_with_tags



# Called when the node enters the scene tree for the first time.
func _ready() -> void:  # Явно задаем размер
	scrollContainer.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
	gridContainer.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
	
	gridContainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	gridContainer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	tmp = Sql.select_all_type_cards_with_tags('BATTLE')
	ALL_cards_with_tags = tmp
	tmp = Sql.select_all_type_cards_with_tags('UPGRADE')
	ALL_cards_with_tags.append_array(tmp)
	
	gridContainer.columns = card_per_row
	upgradeInventory()

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
				if i != 'TypeCard':
					c[i] = CardInfo.card[i]
	)
	card.scale = Vector2(0.66,0.66)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return card

func create_combo(ComboInfo: Dictionary)->Combo:
	var combo = ComboCreator.create(
		func (c:Combo)-> void:
			for i in ComboInfo:
				c[i] = ComboInfo[i] 
	)
	combo.size_flags_horizontal =  Control.SIZE_EXPAND_FILL
	combo.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return combo

func _on_cards_pressed() -> void:
	for child in gridContainer.get_children():
		child.queue_free()
	
	for child_data in PlayerConfig.player_available_cards:
		var card = create_card(child_data)
		gridContainer.add_child(card)
		print("Card added:", card.name)  # Отладочный вывод
	arrange_cards()
	pass 


func _on_combos_pressed() -> void:
	for child in gridContainer.get_children():
		child.queue_free()
		
	gridContainer.columns = 1
	for child_data in PlayerConfig.player_available_combos:
		var combo = create_combo(child_data)
		gridContainer.add_child(combo)
		print("Combo added:", combo.name)
	pass # Replace with function body.


func _on_totem_pressed() -> void:
	print("not worked now")
	pass # Replace with function body.
