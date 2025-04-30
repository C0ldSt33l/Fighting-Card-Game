extends Node
func _ready()-> void:
	pass
var save_name = "save"

func save_file(path: String, data): #path: *.json
	var file = FileAccess.open(path,FileAccess.WRITE)
	if file:
		if data is Array:
			var arr = []
			for obj in data:
				arr.append(obj)
			data = arr
		var json_string = JSON.stringify(data," ")
		file.store_string(json_string)
		file.close()
		
		
func load_file(path:String):
	var file = FileAccess.open(path,FileAccess.READ)
	if file:
		var json_str = file.get_as_text()
		var json = JSON.new()
		var res = json.parse(json_str)
		file.close
		
		if res == OK:
			var data = json.get_data()
			return data
			
	
func save_data(save_name:String):
	save_file("res://save/player/Cards/"+save_name+".json",PlayerConfig.player_available_cards)
	save_file("res://save/player/_Combo_/"+save_name+".json",PlayerConfig.player_available_combos)
	save_file("res://save/player/Totem/"+save_name+".json",PlayerConfig.player_available_combos)
	print("game saved")
	
func load_data(path:String):
	PlayerConfig.player_available_cards = load_file("res://save/player/Cards/"+path+".json")
	PlayerConfig.player_available_combos = load_file("res://save/player/_Combo_/"+path+".json")
	PlayerConfig.player_available_totems = load_file("res://save/player/Totem/"+path+".json")
	print("game load")

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("save_game"):
		print("save start")
		save_data(save_name)
	if Input.is_action_pressed("load_game"):
		print("load start")
		load_data(save_name)
