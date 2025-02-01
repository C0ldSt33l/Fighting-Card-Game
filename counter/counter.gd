extends Node2D
class_name Counter


var Panel_points: Panel
var Label_points :Label

var Panel_mult: Panel
var Label_multipliter :Label

var Label_x : Label

var final_points_panel: Panel
var final_points_label:Label

var final_points = 0
var point :int = 1  :
	set = set_points
var multipliter :int = 1 :
	set = set_multipliter

var is_result_calculated: bool = false


signal points_changed(old: int, new: int, diff: int)
signal multiplier_changed(old: int, new: int, diff: int)
signal total_score_changed(old: int, new: int, diff: int)


func _ready() -> void:
	Label_x = get_node("X")
	
	Panel_points = get_node("Panel/Panel_point")
	Panel_mult = get_node("Panel/panel_mult")
	
	Label_points = get_node("Panel/Panel_point/points")
	Label_multipliter = get_node("Panel/panel_mult/multiplier")
	
	final_points_panel = get_node("final_points")
	final_points_label = get_node("final_points/final_point")
	
	Label_points.text = str(point)
	Label_multipliter.text = str(multipliter)
	
	final_points_panel.visible = false
	final_points_label.visible = false
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(1000):
		await get_tree().create_timer(0.01).timeout
		point= point + 2
		if(point>=1000 && not is_result_calculated):
			final_result()
		return

func set_points(value: int)-> void:
	self.points_changed.emit(self.point, value, value - self.point)
	point = value
	
func get_points()-> int:
	return point
	

func set_multipliter(value: int)-> void:
	self.multiplier_changed.emit(self.multipliter, value, value - self.multipliter)
	multipliter = value
	
	
func get_multipliter()-> int:
	return multipliter
	
func final_result()-> void:
	is_result_calculated = true #хрень которую надо соркатить
	Panel_mult.visible = false
	Panel_points.visible = false
	Label_points.visible = false
	Label_multipliter.visible = false
	Label_x.visible = false
	
	final_points_panel.visible = true
	final_points_label.visible = true
	while(final_points_panel.size.x<=520):
		await get_tree().create_timer(0.01).timeout
		final_points_panel.size.x =final_points_panel.size.x + 4 
	final_points = point * multipliter
	final_points_label.text = str(final_points)
	
	
