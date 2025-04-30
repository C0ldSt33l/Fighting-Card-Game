class_name  Cursor

enum TYPE {
	CARDS,
	COMBOS
}

var type: TYPE

var index: int = 0
var size: int = -1


func _init(type: TYPE):
	self.type = type


func set_index(i: int) -> void:
	self.index = i


func set_size(size: int) -> void:
	self.size = size


func back_to_start() -> void:
	self.index = 0


func reset() -> void:
	self.index = 0
	self.size = -1


func move_foward(steps: int = 1) -> void:
	self.index = clampi(self.index + steps, 0, self.size)


func move_back(steps: int = 1) -> void:
	self.index = clampi(self.index - steps, 0, self.size)
