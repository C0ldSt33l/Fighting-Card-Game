class_name Utils

class Filter:
	static func BY_ACTIVATION_TIME(e: Effect, time: Effect.ACTIVATION_TIME) -> bool:
		return e.activation_time == time

	static func BY_CASTER(e: Effect, caster: Variant) -> bool:
		return e.caster == caster

	static func BY_TARGET(e: Effect, target: Variant) -> bool:
		return e.target == target

	static func BY_ACTIVATION_TIME_AND_CASTER(
		e: Effect,
		time: Effect.ACTIVATION_TIME,
		caster: Variant
	) -> bool:
		return e.activation_time == time and e.target == caster

	static func BY_ACTIVATION_TIME_AND_TARGET(
		e: Effect,
		time: Effect.ACTIVATION_TIME,
		target: Variant
	) -> bool:
		return e.activation_time == time and e.target == target

	static func BY_ACTIVATION_TIME_CASTER_AND_TARGET(
		e: Effect,
		time: Effect.ACTIVATION_TIME, 
		caster: Variant,
		target: Variant
	) -> bool:
		return e.activation_time == time and e.caster == caster and e.target == target

static func exlude_array(from: Array, what: Array) -> Array:
	var res := from.filter(
		func (el) -> bool:
			return what.find(el) == -1
	)
	return res
