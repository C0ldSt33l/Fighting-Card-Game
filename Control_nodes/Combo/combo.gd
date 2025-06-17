extends Control
class_name _Combo_
@onready var Background : Panel = $Background
@onready var NameLabel : Label = $Background/Name
@onready var DescriptionLabel: Label = $Background/Description

signal hovered()
signal unhovered()

var data := {}
var tags : Array = []

var id: int:
	set(val): self.set_tag_val('id', val)
	get(): return self.get_tag_val('id')

var Name: String:
	set(val): self.set_tag_val('Name',"" if val == null else val)
	get(): return self.get_tag_val('Name') if self.get_tag_val('Name') != null else ""

var Description: String:
	set(val): self.set_tag_val('Description',"" if val == null else val)
	get():return self.get_tag_val('Description') if self.get_tag_val('Description') != null else ""
	
var Price:int:
	set(val): self.set_tag_val('Price',val)
	get(): return self.get_tag_val('Price')
	
var Point:int: 
	set(val): self.set_tag_val('Point',val)
	get(): return self.get_tag_val('Point')
	
var Factor:int:
	set(val): self.set_tag_val('Factor',val)
	get(): return self.get_tag_val('Factor')	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.NameLabel.text = str(self.Name)
	self.DescriptionLabel.text = self.Description
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	print("навелся на карту")
	self.hovered.emit(self)
	
func _on_mouse_exited() -> void:
	print("мышь ушла")
	self.unhovered.emit()
	
func set_tag_val(tag: String, val: Variant) -> void:
	self.data[tag] = val
	
func get_tag_val(tag: String) -> Variant:
	return self.data[tag] if self.has_tag(tag) else null
	
func add_tags(new_tags: Dictionary) -> void:
	self.data.merge(new_tags, true)

func has_tag(tag: String) -> bool:
	return self.data.keys().has(tag)
	
func return_all_tags()-> Dictionary:
	return {
			"combo":data,
			"tags":tags
		}
