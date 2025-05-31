class_name Hand
extends Control

@onready var combo_seqment: ComboSeqment = $"HBoxContainer/Combo seqment" as ComboSeqment
@onready var combos: Array[Combo] :
	get(): return self.combo_seqment.combos

var card_count_per_row: int = PlayerConfig.hand_size

@onready var card_segment: CardSegment = $"HBoxContainer/Card Segment" as CardSegment
@onready var cards: Array[Card] :
	get(): return self.card_segment.cards
@onready var card_count: int :
	get(): return self.card_segment.card_container.get_child_count()

@onready var reroll_btn: Button = self.card_segment.reroll_btn
@onready var sort_btn


func _ready() -> void:
	self.card_segment.card_container.columns = self.card_count_per_row
	# self.card_sorter.sort_btn.pressed.connect(self.sort_cards)
	self.card_segment.card_sorter.card_sorted.connect(self.sort_cards)


func add_card(c: Card) -> void:
	self.card_segment.card_container.add_child(c)


func remove_card(c: Card) -> void:
	self.card_segment.card_container.remove_child(c)


func remove_card_by_pos(pos: int):
	var c := self.card_segment.card_container.get_child(pos)
	self.card_segment.card_container.remove_child(c)


func remove_all_cards() -> void:
	for c in self.cards:
		self.remove_card(c)


func sort_cards(f: Callable) -> void:
	var cards := self.cards
	cards.sort_custom(f)
	for pos in len(cards):
		self.card_segment.card_container.move_child(cards[pos], pos)
