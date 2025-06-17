extends Control
class_name CardSegment

@onready var card_container: GridContainer = $"VBoxContainer/Panel/MarginContainer/Card container" as GridContainer
@onready var cards: Array[Card] :
	get():
		var a: Array[Card]
		a.assign(self.card_container.get_children().map(func(w): return w.obj_to_drag))
		return a

@onready var reroll_btn: Button = $"VBoxContainer/Button container/Reroll btn" as Button
@onready var card_sorter: CardSorter = $"VBoxContainer/Button container/Card sorter" as CardSorter
@onready var sort_mode_btns: Array[Button] :
	get(): return self.card_sorter.sort_mode_btns


func add_card(c: Card) -> void:
	var wrapper := DraggableWrap.new(c, Game.battle.hand)
	self.card_container.add_child(wrapper)


func add_card_at_pos(c: Card, pos: int) -> void:
	var wrapper := DraggableWrap.new(c, Game.battle.hand)
	self.card_container.add_child(wrapper)
	self.card_container.move_child(wrapper, pos)


func remove_card(c: Card) -> void:
	for w in self.card_container.get_children():
		if w.get_child(0) == c:
			w.remove_child(c)
			self.card_container.remove_child(w)


func remove_card_at_pos(pos: int) -> void:
	var w := self.card_container.get_child(pos)
	self.card_container.remove_child(w)


func remove_all_cards() -> void:
	for w in self.card_container.get_children():
		self.card_container.remove_child(w)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data.data is Card


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var from = data.from
	var card: Card = data.data
	from.remove_card()
	self.add_card(card)
