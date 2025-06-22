extends Control
class_name ScoreCounter

@onready var h_box_container: HBoxContainer = $HBoxContainer

var points: int = 0 :
	set = set_points
var factor: int = 0 :
	set = set_mult
var round_score: int = 0 :
	set = set_round_score
#var total_score: int = 0

@onready var points_lbl: Label = $"HBoxContainer/points/points lbl"
@onready var mult_lbl: Label = $"HBoxContainer/mult/mult lbl"

@onready var round_score_panel: Panel = $round
@onready var round_score_lbl: Label = $"round/round score lbl"


func _ready() -> void:
	#self.h_box_container.hide()
	pass
	
	
func set_points(val: int) -> void:
	points = val
	self.points_lbl.text = str(val)
	
func set_mult(val: int) -> void:
	factor = val
	self.mult_lbl.text = str(val)

func set_round_score(val: int) -> void:
	round_score = val
	self.round_score_lbl.text = str(val)
	
	
func add(points: int, mult: int) -> void:
	self.points += points
	self.factor += mult
	
func sub(points: int, mult: int) -> void:
	self.points -= points
	self.factor -= mult


func mult(points: int, mult: int) -> void:
	self.points *= points
	self.factor *= mult
	
func reset() -> void:
	self.points = 0
	self.factor = 0
	self.round_score = 0
	self.round_score_panel.hide()

func update_round_score() -> void:
	self.round_score = self.points * self.factor
	self.round_score_panel.show()
