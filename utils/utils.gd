class_name Utils

## Namespace for funcs that filter `Array[Effect]`
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

	static func BY_RESET_ON_CARD(effects: Array[Effect], c: Card) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.reset_time == Effect.RESET_TIME.CARD and (e.caster == c if e.target is not Card else e.target == c)
		)

	static func BY_RESET_ON_COMBO(effects: Array[Effect], c: Combo) -> Array[Effect]:
		return effects.filter(
			func (e: Effect) -> bool:
				return e.reset_time == Effect.RESET_TIME.COMBO and (e.caster == c if e.target is not Combo else e.target == c)
		)

class Factory:
	static func create(scene: Node, modifier: Callable = func (o): return o) -> Node:
		var obj := scene.duplicate()
		modifier.call(obj)
		return obj

	static func create_with_binding(parent: Node, scene: Node, modifier: Callable = func (o): return o) -> Node:
		var obj := create(scene, modifier)
		parent.add_child(obj)
		return obj


static func exlude_array(from: Array, what: Array) -> Array:
	var res := from.filter(
		func (el) -> bool:
			return what.find(el) == -1
	)
	return res


static func get_array_with_uniq_nums(size: int, max: int) -> Array[int]:
	var arr: Array[int] = []
	while arr.size() < size:
		var n := randi_range(0, max)
		if n not in arr:
			arr.append(n)
	return arr

static func colorful(text: String, c: Color) -> String:
	return '[color=#%s]%s[/color]' % [c.to_html(), text]


static func panic(err_text: String) -> void:
	var nil = null
	print(err_text)
	nil.error
