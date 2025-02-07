extends Node2D
class_name Counter


@onready var Panel_points := $Panel/Panel_point as Panel
@onready var Label_points := $Panel/Panel_point/points as Label

@onready var Panel_mult := $Panel/panel_mult as Panel
@onready var Label_multipliter := $Panel/panel_mult/multiplier as Label

@onready var Label_x := $X as Label

@onready var final_points_panel := $final_points as Panel
@onready var final_points_label := $final_points/final_point as Label

var final_points = 0
@onready var points: int = 0 :
	set = set_points
@onready var multiplier: int = 0 :
	set = set_multiplier

var is_result_calculated: bool = false


signal points_changed(old: int, new: int, diff: int)
signal multiplier_changed(old: int, new: int, diff: int)
signal total_score_changed(old: int, new: int, diff: int)


func _ready() -> void:
	self.points = 0
	self.multiplier = 1
	
	final_points_panel.visible = false
	final_points_label.visible = false
	

func set_points(value: int)-> void:
	self.points_changed.emit(self.points, value, value - self.points)
	points = value
	Label_points.text = str(points)
	
func get_points()-> int:
	return points
	

func set_multiplier(value: int)-> void:
	self.multiplier_changed.emit(self.multiplier, value, value - self.multiplier)
	multiplier = value
	Label_multipliter.text = str(multiplier)
	
	
func get_multipliter()-> int:
	return multiplier
	
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
	final_points = points * multiplier
	final_points_label.text = str(final_points)
	
	
