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
	self.card_sorted.emit(self.sort_cards_by_value)


func _on_by_type_pressed() -> void:
	self.card_sorted.emit(self.sort_cards_by_type)


static func sort_cards_by_value(f: Card, s: Card) -> bool:
	return f.point > s.point
