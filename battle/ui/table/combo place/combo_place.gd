extends Control
class_name ComboPlace

@onready var panel: Panel = $Panel as Panel 
var index: int = -1
var combo: FullComboView = null

var FULL_COMBO_VIEW_TEMPLATE: FullComboView = preload("res://battle/combo/full_view/full_combo_view.tscn").instantiate()

var place_range: Array[int]


func _ready() -> void:
	#Events.drag_completed.connect(self.on_drag_completed)
	pass


func is_empty() -> bool:
	return self.combo == null

func get_edge_places_for_combo(c: Variant) -> Array[ComboPlace]:
	var offset: int = c.length - 1
	var first_place_idx := self.index - offset
	var last_place_idx := self.index + offset
	return Game.battle.table.combo_places.slice(first_place_idx, last_place_idx + 1)


func add_combo(c: FullComboView) -> void:
	self.combo = c
	var places := self.get_edge_places_for_combo(c)
	c.cards = Game.battle.table.cards.slice(places[0].index / 2, places[-1].index / 2 + 1)

	for p in places:
		p.combo = c
	self.panel.add_child(c)
	c.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)


func remove_combo() -> void:
	if self.combo == null: return
	
	for p in self.get_edge_places_for_combo(self.combo):
		p.combo = null
	self.panel.remove_child(self.combo)
	self.combo = null


# DRAG N DROP FUNCS
func _get_drag_data(at_position: Vector2) -> Variant:
	if self.combo == null:
		return null
	set_drag_preview(self.combo.get_drag_preview())
	return DragData.new(self, self.combo)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var c = data.data
	if c is not SimpleComboView and c is not FullComboView:
		return false

	# length check
	if (c.length % 2 == self.index % 2):
		return false

	var t := Game.battle.table
	var offset: int = c.length - 1
	var first_place_idx := self.index - offset
	var last_place_idx := self.index + offset
	
	print('FIRST PLACE: ', first_place_idx)
	print('LAST PLACE: ', last_place_idx)

	# check idx range is valid
	if first_place_idx < t.first_place_idx or last_place_idx > t.last_place_idx:
		return false

	# check places from range is empty
	if not (t.combo_places[first_place_idx].is_empty() and t.combo_places[last_place_idx].is_empty()):
		return false

	# check cards is valid
	var cards := t.cards.slice(first_place_idx / 2, (last_place_idx / 2) + 1)
	var cd: ComboData = c.get_combo_data()
	return cd.check_cards(cards)

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var from = data.from
	var combo = data.data
	if combo is SimpleComboView:
		from.remove_combo(combo)
		combo = Utils.Factory.create(
			FULL_COMBO_VIEW_TEMPLATE,
			func (c: FullComboView) -> void:
				c.set_combo_data(combo.get_combo_data())
		)
	else:
		from.remove_combo()
	self.add_combo(combo)
