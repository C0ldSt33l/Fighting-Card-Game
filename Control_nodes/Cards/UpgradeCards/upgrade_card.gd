class_name UpgradeCard extends BaseCard

@onready var Description_label : Label= $Background/TextureRect/Description
@onready var Name_label : Label = $Background/TextureRect/Name
@onready var price: Label = $Background/TextureRect/price
var Price:int:
	set(val): self.set_tag_val('Price',val)
	get(): return self.get_tag_val('Price')
	
func _ready() -> void:
	super()
	price.visible = false
	price.text = "💲" + str(Price)

func set_dragNdrop_func() ->void:
	set_drag_forwarding(
		func (at_position: Vector2) -> Variant:
			set_drag_preview(DragNDropPreview.new(self.Texture_rect.duplicate()))
			return self
			,
		func (at_position: Vector2, data: Variant) -> bool:
			return false
			,
		func (at_position: Vector2, data: Variant) -> void:
			pass
	)
