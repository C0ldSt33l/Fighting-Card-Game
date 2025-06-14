# SaveManager.gd
class_name SaveManager
extends Node

const SAVE_PATH = "user://saves/"

var cards = []
var combos = []
var totems = []

var data = {
	"Money":PlayerConfig.hand_money,
	"Cards":cards,
	"Combo":combos,
	"Totem":totems
}




func _ready() -> void:
	Events.save_game.connect(save_game)

# Сохранить данные
func save_game(name: String):
	var file_path = SAVE_PATH + name + ".json"
	
	cards.append_array(PlayerConfig.player_available_cards)
	combos.append_array(PlayerConfig.player_available_combos)
	totems.append_array(PlayerConfig.player_available_totems)
		
	var json_string = JSON.stringify(data, "  ")  # 2 spaces for pretty-print
	# Open and write to file
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		push_error("Failed to save game: Could not open file for writing at %s" % file_path)
		return
	
	file.store_string(json_string)
	file.close()
	print("Game saved successfully to ", file_path)

# Загрузить данные
func load_game(name: String) -> Dictionary:
	var file = FileAccess.open(SAVE_PATH + name + ".json",FileAccess.READ)
	if not file.file_exists(SAVE_PATH + name + ".json"):
		return {}
	var json_data = file.get_as_text()
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_data)
	if parse_result.error != OK:
		push_error("Ошибка парсинга JSON: " + parse_result.error_string)
		return {}
	
	return parse_result.result as Dictionary

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
