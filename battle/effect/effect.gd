class_name Effect
extends RefCounted

# TODO: Create system of sub-effect for effects
# with multiple target types

var name: String
var description: String
var action: Callable
var args: Array

# TODO: this is shit
# activation_time should has obj that is trigger
# and his state to activate effect
enum ACTIVATION_TIME {
	ROUND_START,
	ROUND_END,

	CARD_START,
	CARD_END,

	COMBO_START,
	COMBO_END,

	TOTEM_ACTIVATION, # TODO: think about it
}
enum RESET_TIME {
	NONE,
	CARD,
	COMBO,
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
	LAST_CARD,
	CARD_IN_COMBO,
	FIRST_CARD_IN_COMBO,
	LAST_CARD_IN_COMBO,
	CUSTOM_CARD,

	COMBO,
	SELF_COMBO,
	NEXT_COMBO,
	PREV_COMBO,
	FIRST_COMBO,
	LAST_COMBO,

	CARD_CURSOR,
	COMBO_CURSOR,

	TOTEM,
	DECK, # or/and HAND?
	SCORE,
}

# TODO: create checker to activate effect on its time

var activation_time: ACTIVATION_TIME :
	set(val): return
var type: TYPE :
	set(val): return
# TODO: create as class
# fields:
# - time count
# - reset time
var max_limit: int :
	set(val): return
var rest_limit: int
var reset_time: RESET_TIME :
	set(val): return

var caster

var target_type: TARGET_TYPE :
	set(val): return
var target


func _init(
	name: String,
	desc: String,
	activation_time: ACTIVATION_TIME,
	reset_time: RESET_TIME,
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
	self.reset_time = reset_time
	self.action = action
	self.type = type
	self.target_type = target_type
	self.max_limit = limit
	self.rest_limit = limit
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
# 			return self.target is _Combo_
# 		Effect.TARGET_TYPE.SCORE:
# 			return self.target is Counter
# 		_:
# 			print('Impossible type for effect target')
# 			return false

func activate():
	print('eff name: ', self.name)
	Events.effect_activated.emit(self)

	var args := [self.target]
	args.append_array(self.args)
	self.action.bindv(args).call()

	self.rest_limit -= 1
	if self.rest_limit <= 0:
		self.make_unenabled()


func make_unenabled() -> void:
	Game.battle.effects.erase(self)
	Game.battle.used_effects.append(self)


func reset() -> void:
	if (self.reset_time == RESET_TIME.NONE): return
	self.rest_limit = self.max_limit
	Game.battle.effects.append(self)
	Game.battle.used_effects.erase(self)


func clone() -> Effect:
	return Effect.new(
		self.name,
		self.description,
		self.activation_time,
		self.reset_time,
		self.action,
		self.type,
		self.target_type,
		self.rest_limit,
		self.args,
		self.caster
	)
