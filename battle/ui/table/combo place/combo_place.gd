extends Control
class_name ComboPlace

var table: Table = null
@onready var panel: Panel = $Panel as Panel 
var index: float = -1
var combo: FullComboView = null

var FULL_COMBO_VIEW_TEMPLATE: FullComboView = preload("res://battle/combo/full_view/full_combo_view.tscn").instantiate()


func _ready() -> void:
	Events.drag_completed.connect(self.on_drag_completed)


func add_combo(c: FullComboView) -> void:
	self.combo = c
	self.panel.add_child(c)
	c.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)


func remove_combo() -> void:
	if self.combo == null: return

	self.panel.remove_child(self.combo)
	self.combo = null


func _get_drag_data(at_position: Vector2) -> Variant:
	Events.drag_started.emit(self.combo, self)
	set_drag_preview(self.combo.get_drag_preview())
	return DragData.new(self, self.combo)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return self.combo == null and (data.data is Combo or data.data is FullComboView)


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var from = data.from
	var combo = data.data
	if combo is Combo:
		from.remove_combo(combo)
		combo = Utils.Factory.create(
			FULL_COMBO_VIEW_TEMPLATE,
			func (c: FullComboView) -> void:
				c.set_combo_data(combo.get_combo_data())
		)
	else:
		from.remove_combo()
	self.add_combo(combo)
	Events.drag_completed.emit(combo, self)


func on_drag_completed(data: Variant, where: Variant) -> void:
	if data == self.combo and where != self:
		self.remove_combo()
