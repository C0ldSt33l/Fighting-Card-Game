class_name Effect
extends RefCounted

# TODO: Create system of sub-effect for effects
# with multiple target types

var name: String
var description: String
var action: Callable
var args: Array

enum ACTIVATION_TIME {
	ROUND_START,
	ROUND_END,
	ROUND_EXIT,

	CARD_START,
	CARD_END,
	CARD_EXIT,

	COMBO_START,
	COMBO_END,
	COMBO_EXIT,
}
enum TYPE {
	BUFF,
	DEBUFF,
}
enum TARGET_TYPE {
	BATTLE_CARD,
	#CARD_IN_COMBO,
	COMBO,
	STANCE, # totem
	DECK, # or/and HAND?
	SCORE,
}

# TODO: think about apply time
var activation_time: ACTIVATION_TIME
var type: TYPE

var caster

var target_type: TARGET_TYPE
var target


func _init(
	name: String,
	desc: String,
	activation_time: ACTIVATION_TIME,
	action: Callable,
	type: TYPE,
	target_type: TARGET_TYPE,
	args: Array = [],
	caster = null,
	target = null 
) -> void:
	self.name = name
	self.description = desc
	self.activation_time = activation_time
	self.action = action
	self.type = type
	self.target_type = target_type
	self.args = args
	self.caster = caster 
	self.target = target
	#self.target = (
		#Game.battle.counter
		#if target_type == Effect.TARGET_TYPE.SCORE
		#else target
	#)


func bind_to(caster):
	self.caster = caster


func set_target(target):
	self.target = target
	Events.effect_applyed.emit(self)


func check_target_type() -> bool:
	match self.target_type:
		Effect.TARGET_TYPE.BATTLE_CARD:
			return self.target is Card
		Effect.TARGET_TYPE.COMBO:
			return self.target is Combo
		Effect.TARGET_TYPE.SCORE:
			return self.target is Counter
		_:
			print('Impossible type for effect target')
			return false

func activate():
	if !self.check_target_type() or self in self.target.used_effects: return

	Events.effect_activated.emit(self)
	var params := [self.target]
	params.append_array(self.args)
	self.action.bindv(params).call()
	self.make_unenabled()


func make_unenabled() -> void:
	self.target.effects.erase(self)
	self.target.used_effects.append(self)
	Game.battle.effects.erase(self)
	Game.battle.used_effects.append(self)


func clone() -> Effect:
	return Effect.new(
		self.name,
		self.description,
		self.activation_time,
		self.action,
		self.type,
		self.target_type,
		self.args,
		self.caster
	)
