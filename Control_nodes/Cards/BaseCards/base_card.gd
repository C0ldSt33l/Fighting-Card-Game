extends Control
class_name BaseCard

@onready var Background:Panel = $Background
var tags := {}

var id: int:
	set(val): self.set_tag_val('id', val)
	get(): return self.get_tag_val('id')

var Name: String:
	set(val): self.set_tag_val('Name',"" if val == null else val)
	get(): return self.get_tag_val('Name') if self.get_tag_val('Name') != null else ""

var Description: String:
	set(val): self.set_tag_val('Description',"" if val == null else val)
	get():return self.get_tag_val('Description') if self.get_tag_val('Description') != null else ""

var Target: String:
	set(val):self.set_tag_val('Target',"" if val == null else val)
	get():return self.get_tag_val('Target') if self.get_tag_val('Target') != null else ""

var Picture: String:
	set(val):self.set_tag_val('Picture',"" if val == null else val)
	get():return self.get_tag_val('Picture') if self.get_tag_val('Picture') != null else ""
	
func set_tag_val(tag: String, val: Variant) -> void:
	self.tags[tag] = val
	
func get_tag_val(tag: String) -> Variant:
	return self.tags[tag] if self.has_tag(tag) else null
	
func add_tags(new_tags: Dictionary) -> void:
	self.tags.merge(new_tags, true)

func has_tag(tag: String) -> bool:
	return self.tags.keys().has(tag)
	
func _on_mouse_entered() -> void:
	self.hovered.emit(self)
	
func _on_mouse_exited() -> void:
	self.unhovered.emit()

func return_all_tags()-> Dictionary:
	return tags

func  return_Background()->Panel:
	return Background

func _ready() -> void:
	self.Name_label.text = str(self.Name)
	self.Description_label.text = self.Description
	pass # Replace with function body.
