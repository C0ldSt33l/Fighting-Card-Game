extends Control
class_name CardSorter 

@onready var sort_btn: Button = $"VBoxContainer/Sort button" as Button
@onready var sort_modes: HBoxContainer = $"VBoxContainer/Sort modes" as HBoxContainer
var sort_mode_btns: Array[Button] :
		get():
			var btns: Array[Button]
			btns.assign(self.sort_modes.get_children())
			return btns
var sort_mode_grp: ButtonGroup = ButtonGroup.new()

var sort_func: Callable


func _ready() -> void:
	self.sort_btn.custom_minimum_size.y = self.size.y / 2
	for b in self.sort_mode_btns:
		b.button_group = self.sort_mode_grp
		b.custom_minimum_size.x = self.size.x / 2
	self.sort_mode_btns[0].button_pressed = true
	self.sort_mode_btns[0].pressed.emit()


func _on_by_value_pressed() -> void:
	self.sort_func = self.sort_cards_by_value


func _on_by_type_pressed() -> void:
	self.sort_func = self.sort_cards_by_type

static func sort_cards_by_value(f: Card, s: Card) -> bool:
	return f.point > s.point


static func sort_cards_by_type(f: Card, s: Card) -> bool:
	return false
