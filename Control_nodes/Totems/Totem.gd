extends Control
class_name Totem

@onready var Background:Panel = $Background

signal hovered()
signal unhovered()

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
	
func _on_mouse_entered() -> void:
	print("навелся на карту")
	self.hovered.emit(self)
	
func _on_mouse_exited() -> void:
	print("мышь ушла")
	self.unhovered.emit()
	
func set_tag_val(tag: String, val: Variant) -> void:
	self.tags[tag] = val
	
func get_tag_val(tag: String) -> Variant:
	return self.tags[tag] if self.has_tag(tag) else null
	
func add_tags(new_tags: Dictionary) -> void:
	self.tags.merge(new_tags, true)

func has_tag(tag: String) -> bool:
	return self.tags.keys().has(tag)
	
func return_all_tags()-> Dictionary:
	return tags
