# SaveManager.gd
class_name SaveManager
extends Node

@export var mode: String = "load"

const SAVE_PATH = "user://saves/"
const SAVE_PATH_META = "user://saves/meta.json"
var cards = []
var combos = []
var totems = []
var nodes = []

var data = {
	"Money":PlayerConfig.hand_money,
	"main_reroll_count" : PlayerConfig.main_reroll_count,
	"extra_reroll_count" : PlayerConfig.extra_reroll_count,
	"reroll_count" : PlayerConfig.reroll_count,
	"pack_in_shop" : PlayerConfig.pack_in_shop,
	"Cards":cards,
	"Combo":combos,
	"Totem":totems,
}


var Meta_data = {
	"Nodes":nodes
}

func _ready() -> void:
	Events.save_game.connect(save_game)
	Events.load_game.connect(load_game)
# Сохранить данные
func save_game(name: String):
	var file_path = SAVE_PATH + name + ".json"
	
	cards.append_array(PlayerConfig.player_available_cards)
	combos.append_array(PlayerConfig.player_available_combos)
	totems.append_array(PlayerConfig.player_available_totems)
	var json_string = JSON.stringify(data, "  ")  
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		push_error("Failed to save game: Could not open file for writing at %s" % file_path)
		return
	
	file.store_string(json_string)
	file.close()
	print("Game saved successfully to ", file_path)

func save_game_meta():
	var file_path = SAVE_PATH_META
	var json_string = JSON.stringify(Meta_data, "  ")  
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		push_error("Failed to save game: Could not open file for writing at %s" % file_path)
		return
	file.store_string(json_string)
	file.close()
	print("Game meta saved successfully to ", file_path)

func load_game_meta():
	var file_path = SAVE_PATH_META
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file or not file.file_exists(file_path):
		push_error("File does not exist: %s" % file_path)
		return {}

	var json_data = file.get_as_text()
	var json_parser = JSON.new()
	var parse_result = json_parser.parse(json_data)
	file.close()
	if !parse_result == OK:
		push_error("Ошибка парсинга JSON: " + parse_result.error_string)
		return {}
	var result = json_parser.get_data() as Dictionary
	nodes = result.get("Nodes",[])
	
	
# Загрузить данные
func load_game(name: String) -> Dictionary:
	var file_path = SAVE_PATH + name + ".json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file or not file.file_exists(file_path):
		push_error("File does not exist: %s" % file_path)
		return {}

	var json_data = file.get_as_text()
	var json_parser = JSON.new()
	var parse_result = json_parser.parse(json_data)
	file.close()
	
	if !parse_result == OK:
		push_error("Ошибка парсинга JSON: " + parse_result.error_string)
		return {}

	var result = json_parser.get_data() as Dictionary

	PlayerConfig.hand_money = result.get("Money", PlayerConfig.hand_money)
	PlayerConfig.reroll_count = result.get("reroll_count",PlayerConfig.reroll_count)
	PlayerConfig.pack_in_shop = result.get("pack_in_shop", PlayerConfig.pack_in_shop)
	PlayerConfig.extra_reroll_count = result.get("extra_reroll_count", PlayerConfig.extra_reroll_count)
	PlayerConfig.player_available_cards = result.get("Cards", [])
	PlayerConfig.player_available_combos = result.get("Combo", [])
	Events.emit_signal("player_data_loaded") 
	print("Game loaded successfully from ", file_path)
	return result

# Получить список всех сохранений
func get_saves() -> Array:
	# Сначала проверяем существует ли директория, если нет - создаем
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		var err = DirAccess.make_dir_recursive_absolute(SAVE_PATH)
		if err != OK:
			push_error("Не удалось создать директорию: " + SAVE_PATH + ", ошибка: " + str(err))
			return []

	var dir = DirAccess.open(SAVE_PATH)
	if dir == null:
		push_error("Не удалось открыть директорию: " + SAVE_PATH)
		return []

	var saves = []
	dir.list_dir_begin()
	var file = dir.get_next()
	print(file)
	while file != "":
		if file.ends_with(".json"):
			saves.append(file.get_basename())
		file = dir.get_next()
	return saves

func auto_save():
	var name = "save_%s" % [get_saves().size() + 1]
	Events.save_game.emit(name)
