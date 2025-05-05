extends Control


@onready var name_label := $HBoxContainer/NameLabel as Label
@onready var value_label := $HBoxContainer/ValueLabel as Label
@onready var slider := $HBoxContainer/SoundSlider as HSlider

@export_enum("Master", "Music", "SFX") var bus_type: String
var bus_index: int


func _ready() -> void:
	self.bus_index = AudioServer.get_bus_index(self.bus_type)
	
	self._set_slider()
	self._set_name_label()
	
	
func _set_value_label() -> void:
	self.value_label.text = str(self.slider.value * 100) + "%"


func _set_name_label() -> void:
	self.name_label.text = self.bus_type + " Volume"
	

func _set_slider() -> void:
	var volume_in_db := AudioServer.get_bus_volume_db(self.bus_index)
	self.slider.value = db_to_linear(volume_in_db)
	self._set_value_label()

	print(self.bus_type, ' ', volume_in_db)


func _on_sound_slider_value_changed(value: float) -> void:
	Settings.set_bus_volume(self.bus_type, value * 100)
	self._set_value_label()
