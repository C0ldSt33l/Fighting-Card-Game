class_name BattleCard extends BaseCard

@onready var Description_label : Label= $Background/TextureRect/Description
@onready var Name_label: Label = $Background/TextureRect/Name
@onready var price: Label = $Background/TextureRect/price
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
	Events.drag_completed.connect(get_upgrade)
	Background.check = func(data):return true
	#price.visible = false
	price.text = str(Price)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_upgrade(c: BaseCard,where:BattleCard) -> void:
	print(c.Target)
	if self != where or not c.Target.contains("CARD"):
		return
	print(Background.get_children().size())
	var data = c.return_all_tags()
	print("start tags")
	print(self.tags)
	self.tags.append_array(data.tags)
	self.remove_child(c)
	print("add tags")
	print(self.tags)
	pass
