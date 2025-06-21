class_name DragData

var from: Variant
var where: Variant
var data: Variant

func _init(from: Variant, data: Variant, where: Variant = null) -> void:
    self.from = from
    self.where = where
    self.data = data