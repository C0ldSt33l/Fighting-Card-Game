extends Node2D
class_name Card

@onready var name_label := $Background/Name as Label
@onready var type_label := $Background/Type as Label
@onready var dmg_label := $Background/DMG as Label

enum ACTION_TYPE {
	ARM_STRIKE,
	LEG_STRIKE,
}

enum RARITY {
	REGULAR,
	RARE,
	LEGENDARY,
}

enum DIRECTION {
	HEAD,
	BODY,
	LEGS,
}

@export var action_name: String
@export_range(1, 10, 1) var dmg: int

# TAGS
@export var type: ACTION_TYPE
@export var rarity: RARITY
@export var direction: DIRECTION
@export var martial_art: String

# NOTE:
#- Think about func signature
#- When apply (during action or before card spawn) 
# if second case => move it in `BattleArena` class
var effects: Array[Callable] = []

signal created(name: String)
signal played(name: String, dealed_dmg: int)
signal destroyed(name: String)


func _ready() -> void:
	self.name_label.text += self.action_name
	self.type_label.text += str(ACTION_TYPE.keys()[self.type])
	self.dmg_label.text += str(self.dmg)
	self.created.emit(self.action_name + ' has created')


func play() -> void:
	# This is test
	var dmg = self.dmg
	for effect in self.effects:
		dmg += effect.call()

	self.played.emit(self.action_name, dmg)


func _exit_tree() -> void:
	self.destroyed.emit(self.action_name)
