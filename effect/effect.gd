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
	CARD,
	SELF_CARD,
	NEXT_CARD,
	PREV_CARD,
	FIRST_CARD,
	CARD_IN_COMBO,

	COMBO,
	SELF_COMBO,
	NEXT_COMBO,
	PREV_COMBO,

	#CARD_CURSOR,
	#COMBO_CURSOR,

	STANCE, # totem
	DECK, # or/and HAND?
	SCORE,
}

var activation_time: ACTIVATION_TIME
var type: TYPE
# TODO: create as class
# fields:
# - time count
# - reset time
var limit: int

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
	limit: int,
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
	self.limit = limit
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

# TODO: replace with switch that handle all use cases
func set_target(target: Variant) -> Effect:
	var copy := self.clone()
	copy.target = target
	Events.effect_applyed.emit(copy)

	return copy


# func check_target_type() -> bool:
# 	match self.target_type:
# 		Effect.TARGET_TYPE.CARD:
# 			return self.target is Card
# 		Effect.TARGET_TYPE.COMBO:
# 			return self.target is Combo
# 		Effect.TARGET_TYPE.SCORE:
# 			return self.target is Counter
# 		_:
# 			print('Impossible type for effect target')
# 			return false

func activate():
	Events.effect_activated.emit(self)

	var args := [self.target]
	args.append_array(self.args)
	self.action.bindv(args).call()

	self.limit -= 1
	if self.limit <= 0:
		self.make_unenabled()


func make_unenabled() -> void:
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
		self.limit,
		self.args,
		self.caster
	)
