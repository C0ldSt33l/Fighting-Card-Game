extends Control
class_name TotemSegment

@onready var totem_container: GridContainer = $"background/MarginContainer/totem container"
var totems: Array[Totem] :
	get():
		var a: Array[Totem]
		a.assign(self.totem_container.get_children())
		return a
		

func _ready() -> void:
	pass
	
	
func swap_totems(f: Totem, s: Totem) -> void:
	pass
