extends Node2D

var Power :Slider
var HandSize :Slider
var PersonalPoint: Label

var CountOfPower: int
var HandSizeValue: int

var PersonalPointValue: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Power = get_node("Power")
	HandSize = get_node("HandSize")
	
	CountOfPower = 0;
	HandSizeValue = 0;
	
	Power.max_value = 3;
	HandSize.max_value = 5
	
	Power.value = CountOfPower
	HandSize.value = HandSizeValue
	
	PersonalPoint = get_node("PersonalPoint")
	PersonalPointValue = PersonalPoint.text.to_int()
	PersonalPointValue = 4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_power_up_button_pressed() -> void:
	if(PersonalPointValue>1 and CountOfPower<Power.max_value):
		PersonalPointValue=PersonalPointValue - 1
		PersonalPoint.text = str(PersonalPointValue)
		CountOfPower = CountOfPower + 1
		Power.value= CountOfPower


func _on_hand_size_button_pressed() -> void:
	if(PersonalPointValue>=1 and HandSizeValue<HandSize.max_value):
		PersonalPointValue=PersonalPointValue - 1
		PersonalPoint.text = str(PersonalPointValue)
		HandSizeValue = HandSizeValue + 1
		HandSize.value = HandSizeValue
