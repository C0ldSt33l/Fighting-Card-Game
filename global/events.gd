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

signal combo_started(c: FullComboView)
signal combo_ended(c: FullComboView)
signal combo_exit(c: FullComboView)

signal effect_applyed(e: Effect)
signal effect_activated(e: Effect)

signal score_points_updated(old: int, new: int, diff: int)
signal score_multiplier_updated(old: int, new: int, diff: int)
signal score_total_score_updated(old: int, new: int, diff: int)

signal hand_updated()

# SHOP EVENTS

signal drag_started(data: Variant, from: Variant)
signal drag_completed(data: Variant, where: Variant)

#SAVE lOAD EVENTS

signal save_game(SaveName: String)
signal load_game(Name: String)

#SKILL TREE
signal skill_tree_scene_opened(StartNode: SkillNode)
signal skill_tree_scene_closed

func connect_events(event_to_func: Dictionary) -> void:
	for e in event_to_func:
		self[e].connect(event_to_func[e])
