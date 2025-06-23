extends Control
class_name Pack
@onready var Background : Panel = $Background
@onready var Texture_rect : TextureRect = $Background/TextureRect
@onready var PackName : Label = $Background/TextureRect/PackName
@onready var PriceLable : Label = $Background/TextureRect/Price
const MAX_DISPLAYED_CARDS : int = 5
var count_selected_obj : int = 5
var objects : Array = []
var is_open : bool = false
var can_open : bool = true
var data := {}
var basket : Array = []

@onready var full_screen_panel: Panel =  $full_screen_panel

var id: int:
	set(val): self.set_tag_val('id', val)
	get(): return self.get_tag_val('id')

var Name: String:
	set(val): self.set_tag_val('Name',"" if val == null else val)
	get(): return self.get_tag_val('Name') if self.get_tag_val('Name') != null else ""

var Description: String:
	set(val): self.set_tag_val('Description',"" if val == null else val)
	get():return self.get_tag_val('Description') if self.get_tag_val('Description') != null else ""

var Picture : String:
	set(val):self.set_tag_val('Picture',"" if val == null else val)
	get():return self.get_tag_val('Picture') if self.get_tag_val('Picture') != null else ""

var Price:int:
	set(val): self.set_tag_val('Price',val)
	get(): return self.get_tag_val('Price')

func set_tag_val(tag: String, val: Variant) -> void:
	self.data[tag] = val
	
func get_tag_val(tag: String) -> Variant:
	return self.data[tag] if self.has_tag(tag) else null
	
func add_tags(new_tags: Dictionary) -> void:
	self.data.merge(new_tags, true)

func has_tag(tag: String) -> bool:
	return self.data.keys().has(tag)
	
func return_all_tags()-> Dictionary:
	return data 

var spawnPos: Vector2

class DoublyLinkedListNode:
	var data
	var prev: DoublyLinkedListNode = null
	var next: DoublyLinkedListNode = null
	
	func _init(data):
		self.data = data

var head: DoublyLinkedListNode = null
var tail: DoublyLinkedListNode = null
var current: DoublyLinkedListNode = null
var displayed_cards = []
var confirm_button

var current_x_pos: float = 50

func add_obj(card_data: Dictionary):
	var new_node = DoublyLinkedListNode.new(card_data)
	
	if head == null:
		head = new_node
		tail = new_node
	else:
		tail.next = new_node
		new_node.prev = tail
		tail = new_node
	head.prev = tail
	tail.next = head

func update_displayed_cards():
	for card in displayed_cards:
		if card.is_inside_tree(): 
			card.queue_free()
	displayed_cards.clear()
	
	current_x_pos = 50
	var node = current
	var count = 0
	var to_display = []
	to_display.append(node)
	count += 1
	var next_node = node.next

	while count < MAX_DISPLAYED_CARDS and next_node != node:
		to_display.append(next_node)
		next_node = next_node.next
		count += 1

	for n in to_display:
		display_card(n)

func display_card(node: DoublyLinkedListNode):
	var obj
	if node.data.has("card"):
		obj = create_card(node.data)
	elif node.data.has("combo"):
		obj = create_combo(node.data)
	else:
		return
	
	obj.position = Vector2(current_x_pos, 100)
	full_screen_panel.add_child(obj)
	displayed_cards.append(obj)
	
	if basket.has(node.data):  
		obj.Background.modulate = Color.GREEN
	else:
		obj.Background.modulate = Color.GRAY
		
	current_x_pos += obj.Background.size.x + 10

func move_left():
	if current and current.prev:
		current = current.prev
		update_displayed_cards()

func move_right():
	if current and current.next:
		current = current.next
		update_displayed_cards()

func add_objects()->void:
	var res = Sql.select_objects_in_pack_by_id(1) 
	for i in res: 
		match i["Object_type"]:
			"BATTLE","UPGRADE","CONSUMABLE":
				for count in range(0,i["Count"]):
					objects.append(Sql.select_typed_card_by_id(i["Object_type"],i["id_object"]))
			"COMBO":
				for count in range(0,i["Count"]):
					objects.append(Sql.select_combo_by_id_with_tags(i["id_object"]))
			"TOTEM":
				print("totem")

func open_pack()-> void:
	Background.visible = false
	var random_objects = []
	
	full_screen_panel.show()
	full_screen_panel.size = get_viewport_rect().size
	
	for i in range(0,15):
		add_obj(objects[randi() % objects.size()])
	self.position = Vector2.ZERO
	full_screen_panel.position = Vector2.ZERO
	if head:
		current = head
		update_displayed_cards()
		
	confirm_button = Button.new()
	full_screen_panel.add_child(confirm_button)
	confirm_button.name = "confirm_button"
	confirm_button.text = "Выбрано 0/" + str(count_selected_obj)
	confirm_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	confirm_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	confirm_button.modulate = Color.CRIMSON
	confirm_button.pressed.connect(confirm_button_pressed)
	confirm_button.position = (get_viewport_rect().size - confirm_button.size)/2
	print(confirm_button.position)

func create_card(CardInfo: Dictionary)-> BaseCard:
	var card := CardCreator.create(CardInfo.card['TypeCard'],
		func (c:BaseCard)-> void:
			for i in CardInfo.card:
				if i == 'Body part' and c is BattleCard:
					c.Type = CardInfo.card[i]
				else:
					c[i] = CardInfo.card[i]
			for i in CardInfo.tags:
				c.tags.append(i)
	)
	card.scale = Vector2(0.66,0.66)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return card

func create_combo(ComboInfo: Dictionary)->_Combo_:
	var combo:= ComboCreator.create(
		func (c:_Combo_)-> void:
			for i in ComboInfo.combo:
				c[i] = ComboInfo.combo[i]
	)
	self.objects.append(combo)
	return combo

func _ready() -> void:
	add_objects()
	full_screen_panel.hide()
	var texture = load(self.Picture)
	PriceLable.text = str(Price) + "💲"
	PriceLable.hide()
	if texture and texture is Texture2D:
		self.Texture_rect.texture = texture
		self.Texture_rect.ExpandMode.EXPAND_IGNORE_SIZE
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		move_left()
	if event.is_action_pressed("ui_right"):
		move_right()
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = get_global_mouse_position()
			if not is_open and can_open and self.Background.get_global_rect().has_point(mouse_pos):
				open_pack()
				is_open = true
			else: 
				for obj in displayed_cards:
					if obj.Background.get_global_rect().has_point(mouse_pos) and !basket.has(obj):
						var card_data = obj.return_all_tags()
						if  basket.size() < count_selected_obj:
							basket.append(card_data)
							obj.Background.modulate = Color.GREEN
							for objects in basket:
								print(objects)
						else:
							basket.erase(card_data)
							obj.Background.modulate = Color.GRAY
						print(basket.size())
						update_confirm_button_text()
						break
func confirm_button_pressed():
	if basket.size() < count_selected_obj:
		return
	print("card size",PlayerConfig.player_available_cards.size())
	print("combo size",PlayerConfig.player_available_combos.size())
	
	for object in basket:
		if object.has("card"):
			PlayerConfig.player_available_cards.append(object)
		if object.has("combo"):
			PlayerConfig.player_available_combos.append(object)
			
	print("card size",PlayerConfig.player_available_cards.size())
	print("combo size",PlayerConfig.player_available_combos.size())
	
	for card in displayed_cards:
		if is_instance_valid(card):
			card.queue_free()
	displayed_cards.clear()
	self.queue_free()
	
	head = null
	tail = null
	current = null
	self.visible = false

func debug_print_all_objects():
	if objects.is_empty():
		print("Пак не содержит объектов.")
		return

	print("=== Содержимое пака ===")
	for i in range(objects.size()):
		var obj = objects[i]
		print("Объект #", i + 1)

		if obj.has("card"):
			var card = obj.card
			print(" - Тип: Карта")
			print("   Название: ", card.Name if card.has("Name") else "Нет имени")
			print("   Тип карты: ", card.TypeCard if card.has("TypeCard") else "Неизвестен")
			print("   Теги: ", card.tags if card.has("tags") else "Нет")

		elif obj.has("combo"):
			var combo = obj.combo
			print(" - Тип: Комбо")
			print("   ID: ", combo.id if combo.has("id") else "Нет ID")
			print("   Название: ", combo.Name if combo.has("Name") else "Нет имени")
			print("   Карты в комбо: ", combo.cards.size() if combo.has("cards") else "0")

		else:
			print(" - Неизвестный тип объекта")

		print("-----------------------")

func update_confirm_button_text():
	if confirm_button:
		confirm_button.text = "Выбрано %d/%d" % [basket.size(), count_selected_obj]
