class_name  Cursor

var index: int = 0
var size: int = -1


func set_index(i: int) -> void:
	self.index = i


func set_size(size: int) -> void:
	self.size = size


func reset() -> void:
	self.index = 0
	self.size = -1


func move_foward(steps: int = 1) -> void:
	self.index = clampi(self.index + steps, 0, self.size)


func move_back(steps: int = 1) -> void:
	self.index = clampi(self.index - steps, 0, self.size)
