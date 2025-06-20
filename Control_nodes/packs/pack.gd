extends Control
class_name Pack
@onready var Background : Panel = $Background
@onready var PackName : Label = $Background/PackName
const MAX_DISPLAYED_CARDS : int = 5
var count_selected_obj : int = 5
var objects : Array = []
var is_open : bool = false
var data := {}
var basket : Array = []
var id: int:
	set(val): self.set_tag_val('id', val)
	get(): return self.get_tag_val('id')

var Name: String:
	set(val): self.set_tag_val('Name',"" if val == null else val)
	get(): return self.get_tag_val('Name') if self.get_tag_val('Name') != null else ""

var Description: String:
	set(val): self.set_tag_val('Description',"" if val == null else val)
	get():return self.get_tag_val('Description') if self.get_tag_val('Description') != null else ""
	
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
	spawnPos = Vector2.ZERO
	var node = current
	var count = 0
	var to_display = []
	# Добавляем текущий элемент
	to_display.append(node)
	count += 1
	# Добавляем следующие по кругу
	spawnPos = Vector2(50,100)
	var next_node = node.next
	while count < MAX_DISPLAYED_CARDS and next_node != node:
		to_display.append(next_node)
		next_node = next_node.next
		count += 1
	# Отображаем
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

	add_child(obj)
	var bg: Panel = obj.Background
	bg.update_minimum_size()
	var screen_width = get_viewport_rect().size.x
	if spawnPos.x + bg.size.x > screen_width:
		obj.queue_free()
		return
	obj.position = spawnPos
	displayed_cards.append(obj)
	if basket.has(node.data):  # сравниваем по данным
		obj.Background.modulate = Color.GREEN
	else:
		obj.Background.modulate = Color.GRAY
	spawnPos.x += bg.size.x + 10

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
	for i in range(0,15):
		add_obj(objects[randi() % objects.size()])
	if head:
		current = head
		update_displayed_cards()
		
	var confirm_button = Button.new()
	add_child(confirm_button)
	confirm_button.text = "Выбрать"
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


	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		move_left()
	if event.is_action_pressed("ui_right"):
		move_right()
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = get_global_mouse_position()
			if not is_open and self.Background.get_global_rect().has_point(mouse_pos):
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
	
	head = null
	tail = null
	current = null
	self.visible = false
