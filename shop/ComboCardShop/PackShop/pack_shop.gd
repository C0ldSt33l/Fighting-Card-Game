extends Node2D

@onready var Money : Label = $Background/Money
@onready var Background : Panel = $Background
@onready var Price : Label = $Background/Button2/Price

var All_packs
var basket = []
var objects = []
var spawn_pos 
var total_price : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_pos = Background.position + Vector2(100,10)
	All_packs = Sql.select_all_packs()
	for i in range(1):
		spawn_pack(All_packs[randi() % All_packs.size()], spawn_pos + Vector2(i * 150, 0))
	arrange_objects(objects)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Money.text = str(PlayerConfig.hand_money) + "💲"
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


func _on_button_pressed() -> void:
	if(PlayerConfig.hand_money>0):
		for pack in objects:
			pack.queue_free()
		objects.clear()
		basket.clear()
		update_total_price()
		for i in range(3):
			spawn_pack(All_packs[randi() % All_packs.size()], spawn_pos + Vector2(i * 150, 0))
		arrange_objects(objects)
		PlayerConfig.hand_money-=1
	pass # Replace with function body.

func update_total_price():
	total_price = 0
	Price.visible = true
	for obj in basket:
		total_price+=obj.Price
	if total_price == 0:
		Price.visible = false
	Price.text = "Total price = %s" % str(total_price)

func spawn_pack(PackInfo : Dictionary, pos: Vector2)-> void: 
	var pack:= PackCreator.create_with_binding(
		self,
		func (p:Pack)-> void:
			for i in PackInfo:
				p[i] = PackInfo[i]
			,
			3, false
	)
	pack.position = pos
	pack.PriceLable.show()
	objects.append(pack)

func arrange_objects(objects: Array, padding_min: int = 20, max_scale: float = 1):
	var container_size = Background.get_rect().size
	var base_size = Vector2(200, 300)
	var card_count = objects.size()
	
	if card_count == 0:
		return
	var final_scale = max_scale

	var scaled_width = base_size.x * final_scale
	var scaled_height = base_size.y * final_scale
	var total_cards_width = scaled_width * card_count

	var min_gaps = padding_min * (card_count - 1)

	var available_space = container_size.x

	if total_cards_width + min_gaps > available_space:
		var current_x = padding_min
		var start_y = (container_size.y - scaled_height) / 2
		for obj in objects:
			obj.scale = Vector2(final_scale, final_scale)
			obj.position = Vector2(current_x, start_y)
			current_x += scaled_width + padding_min
		return
	else:
		var total_gap_space = available_space - total_cards_width
		var gap_between = total_gap_space / (card_count + 1) 

		var current_x = gap_between
		var start_y = (container_size.y - scaled_height) / 2

		for obj in objects:
			obj.scale = Vector2(final_scale, final_scale)
			obj.position = Vector2(current_x + obj.size.x/2, start_y)
			current_x += scaled_width + gap_between


func _on_button_2_pressed() -> void:
	if (PlayerConfig.hand_money - total_price >= 0): 
		PlayerConfig.hand_money -= total_price
		
		var new_object: Array = []
		
		for object in objects:
			if !basket.has(object):
				new_object.append(object)
			else:
				if object is BaseCard:
						PlayerConfig.player_available_cards.append(object.return_all_tags())
				if object is _Combo_:
						PlayerConfig.player_available_combos.append(object.return_all_tags())
				if object is Pack:
						object.position = Vector2(0,0)
						object.modulate = Color.GRAY
						object.debug_print_all_objects()
						object.open_pack()
				#object.queue_free()
		objects = new_object
		basket.clear()
		total_price = 0
		Save_Manager.auto_save()

func _on_inventory_button() -> void:
	SceneManager.__last_scene_type = SceneManager.SCENE.SHOP_ITEMS
	SceneManager.open_new_scene_by_name(SceneManager.SCENE.INVENTORY)

func _on_exit_button() -> void:
	SceneManager.__last_scene_type = SceneManager.SCENE.SHOP_PACK
	SceneManager.close_current_scene()
