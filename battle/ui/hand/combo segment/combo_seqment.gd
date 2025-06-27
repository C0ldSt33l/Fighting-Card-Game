extends Control
class_name ComboSeqment

var SIMPLE_COMBO_VIEW_TEPLATE: SimpleComboView = preload("res://battle/combo/simple_view/simple_combo_view.tscn").instantiate()

@onready var combo_container: VBoxContainer = $"Background/MarginContainer/Combo Container"
var combos: Array[SimpleComboView] :
	get():
		var arr: Array[SimpleComboView]
		arr.assign(self.combo_container.get_children().map(func (w: DraggableWrap) -> SimpleComboView: return w.obj_to_drag))
		return arr


#TODO: handle drag n drop
func _ready() -> void:
	pass


func add_combo(c: SimpleComboView) -> DraggableWrap:
	var wrapper := DraggableWrap.new(c, Game.battle.hand)
	self.combo_container.add_child(wrapper)
	return wrapper

func add_combo_at_pos(c: SimpleComboView, pos: int) -> DraggableWrap:
	var wrapper := self.add_combo(c)
	self.combo_container.move_child(wrapper, pos)
	return wrapper

## Return pos of combo otherwise return `-1`
func remove_combo(c: SimpleComboView) -> int:
	var i := 0
	for w: DraggableWrap in self.combo_container.get_children():
		if w.obj_to_drag == c:
			w.remove_child(c)
			self.combo_container.remove_child(w)
			return i
		i += 1
	return -1

func remove_combo_at_pos(pos: int) -> SimpleComboView:
	if pos >= self.combo_container.get_child_count(): return null

	var w: DraggableWrap = self.combo_container.get_child(pos)
	self.combo_container.remove_child(w)
	return w.obj_to_drag

# NOTE: mayby return array of combos
func remove_all_combos() -> void:
	for c in self.combo_container.get_children():
		self.combo_container.remove_child(c)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return (data.data is SimpleComboView and data.data not in self.combos) or data.data is FullComboView


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var simple_view: SimpleComboView = Utils.Factory.create(
		SIMPLE_COMBO_VIEW_TEPLATE,
		func (c: SimpleComboView) -> void:
			c.set_combo_data(data.data.get_combo_data())
	)

	data.from.remove_combo()
	self.add_combo(simple_view)
