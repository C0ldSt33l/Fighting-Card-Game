extends Node

# var EFFECTS := {
# 	'Damage+': Effect.new(
# 		'Damage+',
# 		'Increase card points by `2`',
# 		Effect.ACTIVATION_TIME.CARD_START,
# 		Effect.TYPE.BUFF,
# 		card_increase_points
# 	),
# 	'Multiplier+': Effect.new(
# 		'Multiplier+',
# 		'Increase card mulitplier by `1`',
# 		Effect.ACTIVATION_TIME.ROUND_START,
# 		Effect.TYPE.BUFF,
# 		card_increase_mult
# 	),
# 	'Double Score': Effect.new(
# 		'Double Score',
# 		'Double score',
# 		Effect.ACTIVATION_TIME.ROUND_END,
# 		Effect.TYPE.BUFF,
# 		score_double_score
# 	),
# }

var EFFECTS := {
	'Extra points': Effect.new(
		'Extra points',
		'Add points and multiplier to score after card is played',
		Effect.ACTIVATION_TIME.CARD_END,
		counter_add_points_and_multipier,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.SCORE,
		1,
		[50, 10],
	),
	'Card enchancment': Effect.new(
		'Card enchancment',
		'Enchance card points and multiplier by %i and %i respectively',
		Effect.ACTIVATION_TIME.COMBO_START,
		card_add_points_and_mulitplier,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.CARD_IN_COMBO,
		1,
		[10, 2],
	),
	'One more time': Effect.new(
		'One more time',
		'Combo activates twice',
		Effect.ACTIVATION_TIME.COMBO_END,
		combo_play_again,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.SELF_COMBO,
		2,
	),
	'Feint': Effect.new(
		'Feint',
		'Activate prev card',
		Effect.ACTIVATION_TIME.CARD_END,
		card_play_prev_card,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.CARD_CURSOR,
		2,
	)
}

# NOTE: effect func name convetion
# TypeName_ActionName(obj: TypeName)

static func counter_add_points_and_multipier(c: Counter, points: int, mult: int) -> void:
	c.add(points, mult)


static func card_add_points_and_mulitplier(c: Card, points: int, mult: int) -> void:
	c.points += points
	c.multiplier += mult


static func card_play_prev_card(c: Cursor) -> void:
	c.move_back(2)


static func combo_play_again(c: Combo) -> void:
	Game.battle.combo_cursor.move_back()
	Game.battle.card_cursor.set_index(c.start_card.index)


func get_effect(name: StringName) -> Effect:
	return self.EFFECTS[name]
