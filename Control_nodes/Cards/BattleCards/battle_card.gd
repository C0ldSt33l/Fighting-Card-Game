class_name BattleCard extends BaseCard

@onready var Description_label:= $Background/Description
@onready var Name_label:=$Background/Name

var Price:int:
	set(val): self.set_tag_val('Price',val)
	get(): return self.get_tag_val('Price')

var Point:int: 
	set(val): self.set_tag_val('Point',val)
	get(): return self.get_tag_val('Point')
	
var Factor:int:
	set(val): self.set_tag_val('Factor',val)
	get(): return self.get_tag_val('Factor')

var Direction:String:
	set(val): self.set_tag_val('Direction',val)
	get():return self.get_tag_val('Direction')

var Type: String:
	set(val): self.set_tag_val('Type',val)
	get(): return self.get_tag_val('Type')
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
