extends Control
class_name DragNDropPreview

var data: Variant = null

var delta: float = 1

func _init(data: Variant) -> void:
    self.data = data
    self.add_child(data)
    data.self_modulate.a = 0.5
    self.data.position = -0.5 * self.data.size


func _physics_process(delta: float) -> void:
    var tween := get_tree().create_tween()
    tween.tween_property(self, "position", get_global_mouse_position(), 1)