extends Node2D
class_name Counter

@onready var score_panel := $Panel as Panel

@onready var panel_points := $Panel/Panel_point as Panel
@onready var label_points := $Panel/Panel_point/points as Label

@onready var panel_mult := $Panel/panel_mult as Panel
@onready var label_multiplier := $Panel/panel_mult/multiplier as Label

@onready var label_x := $X as Label

@onready var final_points_panel := $final_points as Panel
@onready var final_points_label := $final_points/final_point as Label

@onready var points: int = 0 :
	set = set_points
@onready var multiplier: int = 0 :
	set = set_multiplier
@onready var total_score: int = 0 :
	set = set_total_score


signal points_changed(old: int, new: int, diff: int)
signal multiplier_changed(old: int, new: int, diff: int)
signal total_score_changed(old: int, new: int, diff: int)


func _ready() -> void:
	self.points = 0
	self.multiplier = 1
	
	final_points_panel.visible = false
	final_points_label.visible = false
	

func set_points(val: int) -> void:
	self.points_changed.emit(self.points, val, val - self.points)
	points = val
	self.label_points.text = str(val)


func set_multiplier(val: int) -> void:
	self.multiplier_changed.emit(self.multiplier, val, val - self.multiplier)
	multiplier = val
	self.label_multiplier.text = str(val)


func set_total_score(val: int) -> void:
	self.total_score_changed.emit(self.total_score, val, val - self.total_score)
	total_score = val
	self.final_points_label.text = str(val)


func show_score_panel() -> void:
	self.score_panel.show()
	self.label_x.show()


func hide_score_panel() -> void:
	self.score_panel.hide()
	self.label_x.hide()


func show_final_score_panel() -> void:
	self.final_points_panel.show()
	while(self.final_points_panel.size.x<=520):
		await get_tree().create_timer(0.01).timeout
		final_points_panel.size.x =final_points_panel.size.x + 4
	self.final_points_label.show()


func update_round_score()-> void:
	self.hide_score_panel()
	self.show_final_score_panel()	
	self.total_score = self.points * self.multiplier
	
	
