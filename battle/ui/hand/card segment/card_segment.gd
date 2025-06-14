extends Control
class_name CardSegment

@onready var card_container: GridContainer = $"VBoxContainer/Panel/MarginContainer/Card container" as GridContainer
@onready var cards: Array[Card] :
	get():
		var a: Array[Card]
		a.assign(self.card_container.get_children())
		return a

@onready var reroll_btn: Button = $"VBoxContainer/Button container/Reroll btn" as Button
@onready var card_sorter: CardSorter = $"VBoxContainer/Button container/Card sorter" as CardSorter
@onready var sort_mode_btns: Array[Button] :
	get(): return self.card_sorter.sort_mode_btns


func add_card(c: Card) -> void:
	self.card_container.add_child(c)


func add_card_at_pos(c: Card, pos: int) -> void:
	self.card_container.add_child(c)
	self.card_container.move_child(c, pos)


func remove_card(c: Card) -> void:
	self.card_container.remove_child(c)


func remove_card_at_pos(pos: int) -> void:
	var c := self.card_container.get_child(pos)
	self.card_container.remove_child(c)


func remove_all_cards() -> void:
	for c in self.cards:
		self.card_container.remove_child(c)
