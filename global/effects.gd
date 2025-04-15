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
		[50, 10],
	),
	'Card enchancment': Effect.new(
		'Card enchancment',
		'Enchance card points and multiplier by %i and %i respectively',
		Effect.ACTIVATION_TIME.COMBO_START,
		card_add_points_and_mulitplier,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.BATTLE_CARD,
		[10, 2]
	),
}

# NOTE: effect func name convetion
# TypeName_ActionName(obj: TypeName)

static func counter_add_points_and_multipier(c: Counter, points: int, mult: int) -> void:
	c.add(points, mult)


static func card_add_points_and_mulitplier(c: Card, points: int, mult: int) -> void:
	c.points += points
	c.multiplier += mult
