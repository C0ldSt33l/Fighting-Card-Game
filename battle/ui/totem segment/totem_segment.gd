extends Control
class_name TotemSegment

@onready var totem_container: GridContainer = $"background/MarginContainer/totem container"
var totems: Array[Totem] :
	get():
		var a: Array[Totem]
		a.assign(self.totem_container.get_children())
		return a
		
var TOTEM_TEMPLATE: Totem = preload("res://battle/totem/totem.tscn").instantiate()
		

func _ready() -> void:
	var file := 'res://start items.json'
	var dict: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(file))
	var totem_dicts: Array[Dictionary]
	totem_dicts.assign(dict.Totem)
	for d in totem_dicts:
		var totem: Totem = Utils.Factory.create(
			TOTEM_TEMPLATE,
			func (t: Totem) -> void:
				t.effect = Effects.get_effect(d.Effect)
				
				t.totem_name = d.Name
				t.description = t.effect.description
				
		)
		self.add_totem(totem)
		totem.image = load(d.Picture)
		
	
	
func swap_totems(f: Totem, s: Totem) -> void:
	pass

func add_totem(t: Totem) -> void:
	t.pos_idx = self.totem_container.get_child_count()
	self.totem_container.add_child(t)
	
func remove_totem(t: Totem) -> void:
	self.totem_container.remove_child(t)
