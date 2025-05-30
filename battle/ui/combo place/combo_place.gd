extends Control
class_name ComboPlace

@onready var panel: ObjectDropable = $Panel as ObjectDropable 
var index: float = -1
var combo: Combo = null


func _ready() -> void:
	Events.drag_completed.connect(self.on_drag_completed)
	self.panel.check = func(data: Variant) -> bool:
		return data is Card


func add_combo(c: Combo) -> void:
	# self.panel.add_child(c)
	# c.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)

	self.combo = c


func remove_combo() -> void:
	if self.combo == null: return

	self.panel.remove_child(self.panel.held_data)
	self.combo = null
	self.panel.held_data = null


func on_drag_completed(data: Variant, where: Variant) -> void:
	if self != where: return

	self.add_combo(data)
