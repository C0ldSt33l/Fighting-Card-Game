class_name Effect
extends RefCounted

var name: String
var description: String
var action: Callable

enum ACTIVATION_TIME {
	ROUND_START,
	ROUND_END,
	ROUND_IN_PROGRESS,
}
enum TYPE {
	BUFF,
	DEBUFF,
}

var activation_time: ACTIVATION_TIME
var type: TYPE

var caster
var target


signal activated(e: Effect)


func _init(
	name: String,
	desc: String,
	activation_time: ACTIVATION_TIME,
	type: TYPE,
	action: Callable,
	caster = null,
	target = null 
) -> void:
	self.name = name
	self.description = desc
	self.activation_time = activation_time
	self.type = type
	self.action = action
	self.caster = caster 
	self.target = target


func bind_to(caster):
	self.caster = caster


func set_target(target):
	target.add_effect(self)
	self.target = target

	Game.battle.add_effect(self)


func activate():
	self.activated.emit(self)
	self.action.call(self.target)


func clone() -> Effect:
	return Effect.new(
		self.name,
		self.description,
		self.activation_time,
		self.type,
		self.action,
		self.caster
	)
