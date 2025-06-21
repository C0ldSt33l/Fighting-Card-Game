extends Control
class_name CardSorter 

@onready var sort_modes: HBoxContainer = $"PanelContainer/VBoxContainer/MarginContainer/Sort modes" as HBoxContainer

var sort_mode_btns: Array[Button] :
		get():
			var btns: Array[Button]
			btns.assign(self.sort_modes.get_children())
			return btns

signal card_sorted(f: Callable)


func _ready() -> void:
	pass

func _on_by_value_pressed() -> void:
	self.card_sorted.emit(__sort_by_value)


func _on_by_type_pressed() -> void:
	self.card_sorted.emit(__sort_by_type)


static func __sort_by_value(cards: Array[Card]) -> void:
	cards.sort_custom(__sort_cards_by_point)

static func __sort_by_type(cards: Array[Card]) -> void:
	cards.sort_custom(__sort_cards_by_type)
	var sep: int = 0
	var a: Array[Array] = []
	for i in range(1, cards.size()):
		var cur: Card = cards[i]
		var prev: Card = cards[i - 1]
		if cur._material != prev._material:
			a.append(cards.slice(sep, i))
			a[-1].sort_custom(__sort_cards_by_point)
			sep = i 
	cards.clear()
	for cs in a:
		cards.append_array(cs)


static func __sort_cards_by_point(f: Card, s: Card) -> bool:
	return f.point > s.point

static func __sort_cards_by_type(f: Card, s: Card) -> bool:
	return f._material > s._material
