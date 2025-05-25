extends Control
@onready var Background : Panel = $Background
@onready var PackName : Label = $PackName
const MAX_DISPLAYED_CARDS = 3


var objects : Array = []

var data := {}

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
	var data: Dictionary
	var prev: DoublyLinkedListNode = null
	var next: DoublyLinkedListNode = null
	
	func _init(data: Dictionary):
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

func update_displayed_cards():
	for card in displayed_cards:
		card.queue_free()
	displayed_cards.clear()
	
	var node = current
	var count = 0
	var temp = current.prev
	var prev_cards = []
	while temp != null and count < (MAX_DISPLAYED_CARDS - 1) / 2:
		prev_cards.push_front(temp)
		temp = temp.prev
		count += 1
	for n in prev_cards:
		display_card(n)
	display_card(current)

func display_card(node: DoublyLinkedListNode):
	var card = create_card(node.data)
	spawnPos += Vector2(200,0)
	card.position = spawnPos
	add_child(card)
	displayed_cards.append(card)

func move_left():
	if current and current.prev:
		current = current.prev
		update_displayed_cards()

func move_right():
	if current and current.next:
		current = current.next
		update_displayed_cards()

func add_objects()->void:
	var res = Sql.select_objects_in_pack_by_id(1) #!!!!!!!!!!!!!!!!!!!!!!
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
	var random_objects = []
	for i in range(0,15):
		add_obj(objects[randi() % objects.size()])
	pass

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

func _ready() -> void:
	add_objects()
	open_pack()
	if head:
		current = head
		update_displayed_cards()
	
