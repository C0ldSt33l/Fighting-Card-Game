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
	set(val): self.set_tag_val('Body part',val)
	get(): return self.get_tag_val('Body part')
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	Events.drag_completed.connect(get_upgrade)
	Background.check = func(data):return true
	price.visible = false
	price.text = str(Price)
	pass # Replace with function body.

func get_upgrade(c: BaseCard,where:BattleCard) -> void:
	print(c.Target)
	var data = c.return_all_tags()
	print("all tags")
	print(self.tags)
	self.tags.append_array(data.tags)
	print(self.tags)
	pass

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is UpgradeCard and data.Target.contains("CARD")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	get_upgrade(data,self)
	data.get_parent().remove_child(data)
	pass
