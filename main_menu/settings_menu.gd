class_name SettingsMenu
extends Control


signal exit_from_settins_menu


@onready var window_mode_option_button := $MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/WindowModeOptions as OptionButton
@onready var resolution_option_button := $MarginContainer/VBoxContainer2/VBoxContainer/HFlowContainer/ResolutionOptions as OptionButton


func _ready() -> void:
	self._set_window_mode_options()
	self._set_resolution_options()


func _set_window_mode_options() -> void:
	#(
	#self.window_mode_option_button
		#.get_popup()
		#.add_theme_font_size_override('font_size', 32)
	#)
	for mode in Settings.WINDOW_MODE:
		self.window_mode_option_button.add_item(mode)
	self.window_mode_option_button.select(Settings.window_mode as int)


func _set_resolution_options() -> void:
	#(
	#self.resolution_option_button
		#.get_popup()
		#.add_theme_font_size_override('font_size', 32)
	#)
	for option in Settings.RESOLUTION_DIC:
		self.resolution_option_button.add_item(option)

	var index := 0
	for res in Settings.RESOLUTION_DIC.values():
		if res == Settings.resolution:
			self.resolution_option_button.select(index)
			break
		index =+ 1


func _on_window_mode_options_item_selected(index: int) -> void:
	Settings.set_window_mode(index as Settings.WINDOW_MODE)


func _on_resolution_options_item_selected(index: int) -> void:
	Settings.set_window_resolution(Settings.RESOLUTION_DIC.values()[index])


func _on_accept_button_pressed() -> void:
	Settings.save_settings()
	self.exit_from_settins_menu.emit()
