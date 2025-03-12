extends Node

var EFFECTS := {
	'Damage+': Effect.new(
		'Damage+',
		'Increase card points by `2`',
		Effect.ACTIVATION_TIME.ROUND_IN_PROGRESS,
		Effect.TYPE.BUFF,
		card_increase_points
	),
	'Multiplier+': Effect.new(
		'Multiplier+',
		'Increase card mulitpier by `1`',
		Effect.ACTIVATION_TIME.ROUND_START,
		Effect.TYPE.BUFF,
		card_increase_mult
	),
	'Double Score': Effect.new(
		'Double Score',
		'Double score',
		Effect.ACTIVATION_TIME.ROUND_END,
		Effect.TYPE.BUFF,
		score_double_score
	),
}

# NOTE: effect func name convetion
# TypeName_ActionName(obj: TypeName)

static func card_increase_points(c: Card, bonus: int = 2) -> void:
	c.points += bonus


static func card_increase_mult(c: Card, bonus: int = 1) -> void:
	c.multiplier += bonus


static func score_double_score(c: Counter) -> void:
	c.round_score *= 2


static func combo_charge_with_ki(c: Combo) -> void:
	pass


static func card_charge_with_ki(c: Card) -> void:
	c.energy = Card.ENERGY.KI
	pass
