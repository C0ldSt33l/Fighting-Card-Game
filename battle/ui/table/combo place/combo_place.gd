extends Control
class_name ComboPlace

var table: Table = null
@onready var panel: Panel = $Panel as Panel 
var index: float = -1
var combo: Combo = null


func _ready() -> void:
	Events.drag_completed.connect(self.on_drag_completed)


func add_combo(c: Combo) -> void:
	self.combo = c
	self.panel.add_child(c)
	c.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)


func remove_combo() -> void:
	if self.combo == null: return

	self.panel.remove_child(self.combo)
	self.combo = null


func _get_drag_data(at_position: Vector2) -> Variant:
	Events.drag_started.emit(self.combo, self)
	return DragData.new(self, self.combo)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return self.combo == null and data.data is Combo


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var from = data.from
	var combo = data.data
	if from.remove_combo.get_argument_count() > 0:
		from.remove_combo(combo)
	else:
		from.remove_combo()
	self.add_combo(combo)
	Events.drag_completed.emit(combo, self)


func on_drag_completed(data: Variant, where: Variant) -> void:
	if data == self.combo and where != self:
		self.remove_combo()
