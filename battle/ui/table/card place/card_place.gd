extends Control
class_name CardPlace


@onready var panel: Panel = $Panel as Panel
var index: int = -1
var card: Card = null


func _ready() -> void:
	#Events.drag_completed.connect(self.on_drag_completed)
	pass



func add_card(c: Card) -> void:
	self.panel.add_child(c)
	# c.size = self.card.background.size
	c.set_anchors_and_offsets_preset(PRESET_CENTER, PRESET_MODE_KEEP_SIZE)

	self.card = c
	c.index = self.index


func remove_card() -> void:
	if self.card == null: return

	self.panel.remove_child(self.card)
	self.card = null


func _get_drag_data(at_position: Vector2) -> Variant:
	if self.card == null:
		return null
	#Events.drag_started.emit(self.card, self)
	set_drag_preview(self.card.get_drag_preview())
	return DragData.new(self, self.card)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return self.card == null and data.data is Card 


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var from = data.from
	var card = data.data
	if from.remove_card.get_argument_count() > 0:
		from.remove_card(card)
	else:
		from.remove_card()
	self.add_card(card)
	#Events.drag_completed.emit(card, self)


func on_drag_completed(data: Variant, where: Variant) -> void:
	if data == self.card and where != self:
		self.remove_card()
