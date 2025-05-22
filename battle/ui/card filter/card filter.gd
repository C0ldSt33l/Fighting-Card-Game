extends Control
class_name CardFilter

@onready var filter_btn: Button = $"VBoxContainer/Filter button" as Button
@onready var filter_modes: HBoxContainer = $"VBoxContainer/Filter modes" as HBoxContainer
var filter_mode_btns: Array[Button] :
		get():
			var btns: Array[Button]
			btns.assign(self.filter_modes.get_children())
			return btns
var filter_mode_grp: ButtonGroup = ButtonGroup.new()

func _ready() -> void:
	for b in self.filter_mode_btns:
		b.button_group = self.filter_mode_grp
