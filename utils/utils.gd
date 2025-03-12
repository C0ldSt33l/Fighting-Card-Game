class_name Utils

static func apply_effect_to(obj: Variant, e: Effect) -> void:
	if 'add_effect' in obj:
		obj.add_effect(e)
	Game.battle.add_effect(e)

static func connect_signals(obj: Variant, what_to_what: Dictionary) -> Variant:
	for s in what_to_what:
		obj[s].connect(what_to_what[s])
		
	return obj