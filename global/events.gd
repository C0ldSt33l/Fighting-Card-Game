extends Node

# COMMON EVENTS
signal obj_created(obj: Variant)
signal obj_prop_changed(
	obj: Variant,
	prop: StringName,
	old: int,
	new: int
)
signal obj_destroyed(obj: Variant)

signal rerolled()

# BATTLE EVENTS
signal battle_started()
signal battle_ended()

signal round_preparation_started()
signal round_started()
signal round_ended()
signal round_exit()

signal card_started(c: Card)
signal card_ended(c: Card)
signal card_exit(c: Card)

signal combo_started(c: Combo)
signal combo_ended(c: Combo)
signal combo_exit(c: Combo)

signal effect_applyed(e: Effect)
signal effect_activated(e: Effect)

signal score_points_updated(old: int, new: int, diff: int)
signal score_multiplier_updated(old: int, new: int, diff: int)
signal score_total_score_updated(old: int, new: int, diff: int)

signal hand_updated()

# SHOP EVENTS


func connect_events(event_to_func: Dictionary) -> void:
	for e in event_to_func:
		self[e].connect(event_to_func[e])
