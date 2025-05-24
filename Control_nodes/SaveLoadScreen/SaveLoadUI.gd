# SaveLoadUI.gd
extends Control

@onready var SavesListContainer = $Panel/ScrollContainer/VBoxContainer
@export var save_slot_template = preload("res://Control_nodes/SaveLoadScreen/SaveSlot.tscn")
@export var mode: String = "save"  # "save" или "load"

var selected_save_name: String = ""

func _ready():
	refresh_saves()

func refresh_saves():
	for c in SavesListContainer.get_children():
		c.queue_free()
	
	var saves = Save_Manager.get_saves()
	for save_name in saves:
		var slot = save_slot_template.instantiate()
		slot.set_save_name(save_name)
		SavesListContainer.add_child(slot)
	
	if mode == "save":
		add_add_new_button()

func add_add_new_button():
	var slot = save_slot_template.instantiate()
	SavesListContainer.add_child(slot)
	slot.button.pressed.connect(_on_add_button_gui_input)
	slot.name = "AddNewSaveButton"
	slot.button.text = "+"

func _on_add_button_gui_input():
	var name = "save_%d" % (Save_Manager.get_saves().size() + 1)
	if mode == "save":
		Events.save_game.emit(name)
		refresh_saves()
	selected_save_name = name
