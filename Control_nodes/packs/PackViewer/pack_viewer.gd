extends Panel

@onready var content_container : Control = $ContentContainer  # например, Control
@onready var confirm_button : Button = $ConfirmButton

var pack_ref: WeakRef

var displayed_cards = []
var selected_cards = []

func set_pack(pack: Pack):
	pack_ref = weakref(pack)
	displayed_cards = pack.displayed_cards.duplicate()  # предположим, что это массив объектов
	selected_cards.clear()

	for card in displayed_cards:
		card.set_process(true)
		card.set_physics_process(true)
		card.show()
		content_container.add_child(card)

	# Расставляем карты
	arrange_cards(displayed_cards)

func arrange_cards(cards):
	var spawn_pos = Vector2(50, 100)
	var spacing = 200
	for card in cards:
		card.position = spawn_pos
		spawn_pos.x += card.get_rect().size.x + spacing

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos = get_global_mouse_position()
		for card in displayed_cards:
			if card.get_global_rect().has_point(mouse_pos):
				toggle_selection(card)
				break

func toggle_selection(card):
	if selected_cards.has(card):
		selected_cards.erase(card)
		card.Background.modulate = Color.GRAY
	else:
		if selected_cards.size() < count_selected_obj:
			selected_cards.append(card)
			card.Background.modulate = Color.GREEN

func _on_confirm_button_pressed():
	var pack = pack_ref.get_ref()
	if pack and selected_cards.size() == pack.count_selected_obj:
		for card in selected_cards:
			if card is BaseCard:
				PlayerConfig.player_available_cards.append(card.return_all_tags())
			elif card is _Combo_:
				PlayerConfig.player_available_combos.append(card.return_all_tags())

		# Удаляем только выбранные карты или всё
		for card in displayed_cards:
			card.queue_free()
		queue_free()
