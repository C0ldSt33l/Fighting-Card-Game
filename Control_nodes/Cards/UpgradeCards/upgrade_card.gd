class_name UpgradeCard extends BaseCard

@onready var Description_label:= $Background/Description
@onready var Name_label:=$Background/Name

var Price:int:
	set(val): self.set_tag_val('Price',val)
	get(): return self.get_tag_val('Price')
	
func _ready() -> void:
	super()
