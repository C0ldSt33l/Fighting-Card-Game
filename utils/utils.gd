class_name Utils

class Filter:
	static func BY_ACTIVATION_TIME(effects: Array[Effect], time: Effect.ACTIVATION_TIME) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.activation_time == time
		)

	static func BY_RESET_TIME(effects: Array[Effect], time: Effect.RESET_TIME) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.reset_time == time
		)

	static func BY_CASTER(effects: Array[Effect], caster: Variant) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.caster == caster
		)

	static func BY_TARGET(effects: Array[Effect], target: Variant) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.target == target
		)

	static func BY_ACTIVATION_TIME_AND_CASTER(
		effects: Array[Effect],
		time: Effect.ACTIVATION_TIME,
		caster: Variant,
	) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.activation_time == time and e.caster == caster
		)

	static func BY_ACTIVATION_TIME_AND_TARGET(
		effects: Array[Effect],
		time: Effect.ACTIVATION_TIME,
		target: Variant
	) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.activation_time == time and e.target == target
		)

	static func BY_ACTIVATION_TIME_CASTER_AND_TARGET(
		effects: Array[Effect],
		time: Effect.ACTIVATION_TIME, 
		caster: Variant,
		target: Variant
	) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.activation_time == time and e.caster == caster and e.target == target
		)

	static func BY_ACTIVATION_ON_CARD(effects: Array[Effect], time: Effect.ACTIVATION_TIME, c: Card) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.activation_time == time and (e.caster == c if e.target is not Card else e.target == c)
		)

	static func BY_ACTIVATION_ON_COMBO(effects: Array[Effect], time: Effect.ACTIVATION_TIME, c: Combo) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.activation_time == time and (e.caster == c if e.target is not Combo else e.target == c)
		)

static func exlude_array(from: Array, what: Array) -> Array:
	var res := from.filter(
		func (el) -> bool:
			return what.find(el) == -1
	)
	return res


static func throw_error(err_text: String) -> void:
	var nil = null
	print(err_text)
	nil.error
