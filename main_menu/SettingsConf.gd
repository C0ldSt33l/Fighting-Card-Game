extends Node

const SAVE_FILE_PATH := 'user://settings.data'

enum WINDOW_MODE {
	FULL_SCREEN,
	WINDOWED,
}
const RESOLUTION_DIC: Dictionary = {
	"640x480": Vector2i(640, 480),
	"1280x720": Vector2i(1280, 720),
	"1920x1080": Vector2i(1920, 1080),
}

var window_mode: WINDOW_MODE = WINDOW_MODE.WINDOWED
var resolution: Vector2i = RESOLUTION_DIC.values()[0]

var master_volume: int = 100
var music_volume: int = 100
var sfx_volume: int = 100


func _ready() -> void:
	# print(self.get_property_list())
	self._print_settings()
	if !FileAccess.file_exists(self.SAVE_FILE_PATH):
		self._set_default()
		self.save_settings()
	else:
		self.load_settings()
		self._print_settings()



func save_settings() -> void:
	print('Save settings')

	var file = FileAccess.open(self.SAVE_FILE_PATH, FileAccess.WRITE)
	var save_data := {
		'window mode': self.window_mode,
		'resolution.x': self.resolution.x,
		'resolution.y': self.resolution.y,

		'master volume': self.master_volume,
		'music volume': self.music_volume,
		'sfx volume': self.sfx_volume,
	}
	for setting in save_data:
		const format := '%s: %s'
		file.store_line(format % [setting, save_data[setting]])

	file.close()


func load_settings() -> void:
	print('Load settings')
	var save_file := FileAccess.open(self.SAVE_FILE_PATH, FileAccess.READ)
	var load_data: Dictionary
	
	while save_file.get_position() < save_file.get_length():
		var words := save_file.get_line().split(': ')
		var key := words[0]
		var val := words[1]
		load_data[key] = val

	self.set_window_mode(load_data['window mode'] as WINDOW_MODE)
	self.set_window_resolution(Vector2i(
		load_data['resolution.x'] as int,
		load_data['resolution.y'] as int
	))
	self.set_bus_volume('Master', load_data['master volume'] as int)
	self.set_bus_volume('Music', load_data['music volume'] as int)
	self.set_bus_volume('SFX', load_data['sfx volume'] as int)
	
	save_file.close()


func set_bus_volume(bus_name: String, volume: float) -> void:
	self[bus_name.to_lower() + '_volume'] = volume

	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_in_db = linear_to_db(volume / 100)
	print('volume in db ', volume_in_db)
	print('volume ', volume)
	print('volume / 100: ', volume / 100)
	AudioServer.set_bus_volume_db(bus_index, volume_in_db)

	print(bus_name, ' ', volume_in_db)


func set_window_mode(mode: WINDOW_MODE) -> void:
	self.window_mode = mode
	match mode:
		WINDOW_MODE.FULL_SCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		WINDOW_MODE.WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_:
			print("Error: Coudn't to set window mode")
	self._center_window()


func set_window_resolution(new_resolution: Vector2i) -> void:
	self.resolution = new_resolution
	self.get_window().set_size(resolution)
	self._center_window()


func _center_window() -> void:
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = DisplayServer.window_get_size()
	self.get_window().set_position(screen_center - window_size / 2)   


func _set_default() -> void:
	self.set_window_mode(self.window_mode)
	self.set_window_resolution(self.resolution)
	
	self.set_bus_volume('Master', self.master_volume)
	self.set_bus_volume('Music', self.music_volume)
	self.set_bus_volume('SFX', self.sfx_volume)


func _print_settings() -> void:
	print('SETTINGS')
	print('window mode ', self.window_mode)
	print('resolution ', self.resolution)
	print('master volume ',self.master_volume)
	print('music volume ',self.music_volume)
	print('sfx volume ', self.sfx_volume)
