# SaveLoadUI.gd
extends Control

@onready var SavesListContainer = $Panel/ScrollContainer/VBoxContainer
@export var save_slot_template = preload("res://Control_nodes/SaveLoadScreen/SaveSlot.tscn")
  # "save" или "load"

var selected_save_name: String = ""

func _ready():
	refresh_saves()

func refresh_saves():
	for c in SavesListContainer.get_children():
		c.queue_free()
	
	var saves = Save_Manager.get_saves()
	for save_name in saves:
		var slot = save_slot_template.instantiate()
		SavesListContainer.add_child(slot)
		slot.name = save_name
		slot.button.text = save_name
		slot.button.pressed.connect(on_save_button_input.bind(save_name))
	if Save_Manager.mode == "save":
		add_add_new_button()

func add_add_new_button():
	var slot = save_slot_template.instantiate()
	SavesListContainer.add_child(slot)
	slot.button.pressed.connect(_on_add_button_gui_input)
	slot.name = "AddNewSaveButton"
	slot.button.text = "+"

func _on_add_button_gui_input():
	var name = "save_%s" % [Save_Manager.get_saves().size() + 1]
	if Save_Manager.mode == "save":
		Events.save_game.emit(name)
		refresh_saves()
	selected_save_name = name

func on_save_button_input(name: String):
	if Save_Manager.mode == "save":
		Events.save_game.emit(name)
	if Save_Manager.mode == "load":
		Events.load_game.emit(name)
