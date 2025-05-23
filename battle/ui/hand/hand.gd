class_name Hand
extends Control

@onready var background: Panel = $VBoxContainer/Panel as Panel
@onready var margins: MarginContainer = $VBoxContainer/Panel/MarginContainer as MarginContainer
@onready var card_container: GridContainer = $VBoxContainer/Panel/MarginContainer/GridContainer as GridContainer
@onready var card_sorter: CardSorter = $"VBoxContainer/Card sorter" as CardSorter
@onready var v_box_container: VBoxContainer = $VBoxContainer

var card_count_per_row: int = PlayerConfig.hand_size

var cards: Array[Card] :
	get():
		var cs: Array[Card]
		cs.assign(self.card_container.get_children())
		return cs
var card_count: int :
	get(): return self.card_container.get_child_count()


func _ready() -> void:
	self.card_container.columns = self.card_count_per_row
	self.card_sorter.sort_btn.pressed.connect(self.sort_cards)
	print(self.size)
	#self.v_box_container.add_theme_constant_override('Separation', self.size.y / 2)


func add_card(c: Card) -> void:
	self.card_container.add_child(c)


func remove_all_cards() -> void:
	for c in self.cards:
		self.card_container.remove_child(c)


func sort_cards() -> void:
	var cards := self.cards
	cards.sort_custom(self.card_sorter.sort_func)
	for pos in len(cards):
		self.card_container.move_child(cards[pos], pos)
