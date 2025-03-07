class_name _UpgradeCard_ extends _Card_

@onready var Name_label:= $Panel/Label
@onready var Background:=$Panel

var Price:int:
	set(val): self.set_tag_val('Price',val)
	get(): return self.get_tag_val('Price')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Name_label.text = str(self.Name)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
