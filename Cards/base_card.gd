extends Node2D
class_name _Card_ 

var id: int:
	set(val): self.set_tag_val('id', val)
	get(): return self.get_tag_val('id')

var Name: String:
	set(val): self.set_tag_val('Name',val)
	get(): return self.get_tag_val('Name')

var Description: String:
	set(val): self.set_tag_val('Description',val)
	get():return self.get_tag_val('Description')

var Picture: String:
	set(val):self.set_tag_val('Picture',"" if val == null else val)
	get():return self.get_tag_val('Picture')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var tags := {}

func set_tag_val(tag: String, val: Variant) -> void:
	self.tags[tag] = val
	
func get_tag_val(tag: String) -> Variant:
	return self.tags[tag] if self.has_tag(tag) else null
	
func add_tags(new_tags: Dictionary) -> void:
	self.tags.merge(new_tags, true)

func has_tag(tag: String) -> bool:
	return self.tags.keys().has(tag)
