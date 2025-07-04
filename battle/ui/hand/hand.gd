class_name Hand
extends Control

@onready var combo_seqment: ComboSeqment = $"HBoxContainer/Combo seqment" as ComboSeqment
@onready var combos: Array[SimpleComboView] :
	get(): return self.combo_seqment.combos

var card_count_per_row: int = 5 #PlayerConfig.hand_size / 2

@onready var card_segment: CardSegment = $"HBoxContainer/Card Segment" as CardSegment
@onready var cards: Array[Card] :
	get(): return self.card_segment.cards
@onready var card_count: int :
	get(): return self.card_segment.card_container.get_child_count()

@onready var reroll_btn: Button = self.card_segment.reroll_btn
@onready var sort_btn


func _ready() -> void:
	self.card_segment.card_container.columns = self.card_count_per_row
	self.card_segment.card_sorter.card_sorted.connect(self.sort_cards)


func add_card(c: Card) -> DraggableWrap:
	return self.card_segment.add_card(c)

func add_card_at_pos(c: Card, pos: int) -> DraggableWrap:
	return self.card_segment.add_card_at_pos(c, pos)

func remove_card(c: Card) -> int:
	return self.card_segment.remove_card(c)

func remove_card_at_pos(pos: int) -> Card:
	return self.card_segment.remove_card_at_pos(pos)

func remove_all_cards() -> void:
	self.card_segment.remove_all_cards()

func sort_cards(sorter: Callable) -> void:
	var cards := self.cards
	sorter.call(cards)
	for pos in len(cards):
		self.card_segment.card_container.move_child(cards[pos].get_parent(), pos)


func add_combo(c: SimpleComboView) -> DraggableWrap:
	return self.combo_seqment.add_combo(c)

func add_combo_at_pos(c: SimpleComboView, pos: int) -> DraggableWrap:
	return self.combo_seqment.add_combo_at_pos(c, pos)

## Return pos of combo otherwise return `-1`
func remove_combo(c: SimpleComboView) -> int:
	return self.combo_seqment.remove_combo(c)

# TODO: replace `SimpleComboView` with `ComboData`
func remove_combo_at_pos(pos: int) -> SimpleComboView:
	return self.combo_seqment.remove_combo_at_pos(pos)

func remove_all_combos() -> void:
	self.combo_seqment.remove_all_combos()


func add_consumable(c: Consumable) -> void:
	pass

func add_consumable_at_pos(c: Consumable, pos: int) -> void:
	pass

func remove_consumable(c: Consumable) -> void:
	pass

func remove_consumable_at_pos(pos: int) -> void:
	pass