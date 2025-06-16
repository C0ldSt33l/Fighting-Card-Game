extends Control
class_name CardPlace


@onready var panel: ObjectDropable = $Panel as ObjectDropable 
var index: int = -1
var card: Card = null


func _ready() -> void:
	Events.drag_completed.connect(self.on_drag_completed)



func add_card(c: Card) -> void:
	self.panel.add_child(c)
	# c.size = self.card.background.size
	c.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)

	self.card = c
	c.index = self.index


func remove_card() -> void:
	if self.card == null: return

	self.panel.remove_child(self.panel.held_data)
	self.card = null
	self.panel.held_data = null


func on_drag_completed(data: Variant, where: Variant) -> void:
	if self.card == data and where != self:
		self.remove_card()
		return

	if self != where: return

	self.add_card(data)
