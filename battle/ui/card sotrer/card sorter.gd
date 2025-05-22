extends Control
class_name CardSorter 

@onready var filter_btn: Button = $"VBoxContainer/Filter button" as Button
@onready var filter_modes: HBoxContainer = $"VBoxContainer/Filter modes" as HBoxContainer
var filter_mode_btns: Array[Button] :
		get():
			var btns: Array[Button]
			btns.assign(self.filter_modes.get_children())
			return btns
var filter_mode_grp: ButtonGroup = ButtonGroup.new()

var filter_func: Callable


func _ready() -> void:
	self.filter_modes.queue_sort()
	for b in self.filter_mode_btns:
		b.button_group = self.filter_mode_grp
		b.custom_minimum_size.x = self.size.x / 2


func _on_by_value_pressed() -> void:
	self.filter_func = self.sort_cards_by_value


func _on_by_type_pressed() -> void:
	self.filter_func = self.sort_cards_by_type

static func sort_cards_by_value(f: Card, s: Card) -> bool:
	return f.point > s.point


static func sort_cards_by_type(f: Card, s: Card) -> bool:
	return false