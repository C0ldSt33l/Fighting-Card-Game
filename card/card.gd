extends Node2D
class_name Card

@onready var name_label := $Background/Name as Label
@onready var type_label := $Background/Type as Label
@onready var dmg_label := $Background/DMG as Label

enum ACTION_TYPE {
	ARM_STRIKE,
	LEG_STRIKE,
}

@export var action_name: String
@export var type: ACTION_TYPE
@export_range(1, 10, 1) var dmg: int

signal created(name: String)
signal played(name: String, dealed_dmg: int)


func _ready() -> void:
	self.name_label.text += self.action_name
	self.type_label.text += str(ACTION_TYPE.keys()[self.type])
	self.dmg_label.text += str(self.dmg)
	self.created.emit(self.action_name)


func _process(delta: float) -> void:
	pass
