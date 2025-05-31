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
