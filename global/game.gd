extends Node

var main_menu = null
var map = null
var battle: BattleScene = null
var shop = null

const log_win_scene := preload("res://logger/logger_window.tscn")
var logger_enable := true 
var log_win: Window = null


func _ready() -> void:
	if self.logger_enable:
		#ProjectSettings.set_setting('display/window/subwindows/embed_subwindows', false)
		#ProjectSettings.save_custom('custom_settings')
		self.log_win = self.log_win_scene.instantiate()
		self.add_child(self.log_win)
		
