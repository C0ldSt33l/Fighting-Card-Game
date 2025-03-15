class_name Utils

static func apply_effect( e: Effect, to: Variant) -> void:
	e.set_target(to)
	to.add_effect(e)
	Game.battle.add_effect(e)

static func connect_signals(obj: Variant, what_to_what: Dictionary) -> Variant:
	for s in what_to_what:
		obj[s].connect(what_to_what[s])
		
	return obj
