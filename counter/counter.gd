class_name Counter
extends Node2D

@onready var score_panel := $Panel as Panel

@onready var panel_points := $Panel/Panel_point as Panel
@onready var label_points := $Panel/Panel_point/points as Label

@onready var panel_mult := $Panel/panel_mult as Panel
@onready var label_multiplier := $Panel/panel_mult/multiplier as Label

@onready var label_x := $Panel/X as Label

@onready var round_score_panel := $final_points as Panel
@onready var round_score_label := $final_points/final_point as Label

@onready var points: int = 0 :
	set = set_points
@onready var multiplier: int = 0 :
	set = set_multiplier
@onready var round_score: int = 0 :
	set = set_round_score
@onready var total_score: int = 0

var effects: Array[Effect] = []
var used_effects: Array[Effect] = []


func _ready() -> void:
	self.label_points.text = str(0)	
	self.label_multiplier.text = str(0)	

	round_score_panel.visible = false
	

func set_points(val: int) -> void:
	Events.score_points_updated.emit(self.points, val, val - self.points)
	points = val
	self.label_points.text = str(val)


func set_multiplier(val: int) -> void:
	Events.score_multiplier_updated.emit(self.multiplier, val, val - self.multiplier)
	multiplier = val
	self.label_multiplier.text = str(val)


func set_round_score(val: int) -> void:
	Events.score_total_score_updated.emit(self.round_score, val, val - self.round_score)
	round_score = val
	self.round_score_label.text = str(val)


func zero_score() -> void:
	self.points = 0
	self.multiplier = 0


func add(points: int, mult: int) -> void:
	self.points += points
	self.multiplier += mult


func sub(points: int, mult: int) -> void:
	self.points -= points
	self.multiplier -= mult


func add_effect(e: Effect) -> void:
	self.effects.append(e)


func show_score_panel() -> void:
	self.score_panel.show()
	self.round_score_panel.hide()


func hide_score_panel() -> void:
	self.score_panel.hide()


func show_final_score_panel() -> void:
	self.round_score_panel.show()
	self.round_score_panel.size.x = 0
	while(self.round_score_panel.size.x < self.score_panel.size.x):
		await get_tree().create_timer(0.01).timeout
		round_score_panel.size.x =round_score_panel.size.x + 4
	self.round_score_label.show()


func update_round_score()-> void:
	self.hide_score_panel()
	await self.show_final_score_panel()	
	self.round_score = self.points * self.multiplier
	self.zero_score()
	
	
	
