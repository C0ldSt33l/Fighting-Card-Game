class_name Score

var points := 0 :
	set = set_points
var multiplier := 1 :
	set = set_multiplier


signal points_changed(old: int, new: int, diff: int)
signal multiplier_changed(old: int, new: int, diff: int)


func set_points(val: int) -> void:
	self.points_changed.emit(self.points, val, val - self.points)
	self.points = val


func set_multiplier(val: int) -> void:
	self.multiplier_changed.emit(self.multiplier, val, val - self.multiplier)
	self.multiplier = val


func calculate_score() -> int:
	return self.points * self.multiplier
