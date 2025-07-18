extends Node

var EFFECTS := {
	'Extra points': Effect.new(
		'Extra points',
		'Add points and multiplier to score after card is played',
		Effect.ACTIVATION_TIME.CARD_END,
		Effect.RESET_TIME.CARD,
		counter_add_points_and_multiplier,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.SCORE,
		1,
		[50, 10],
	),
	'Card enchancment': Effect.new(
		'Card enchancment',
		'Enchance card points and multiplier by %i and %i respectively',
		Effect.ACTIVATION_TIME.COMBO_START,
		Effect.RESET_TIME.NONE,
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
		Effect.RESET_TIME.COMBO,
		combo_play_again,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.SELF_COMBO,
		1,
	),
	'Feint': Effect.new(
		'Feint',
		'Activate prev card',
		Effect.ACTIVATION_TIME.CARD_END,
		Effect.RESET_TIME.ROUND,
		card_play_prev_card,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.CARD_CURSOR,
		1,
	),
	'First strike': Effect.new(
		'First strike',
		'Multiply points and multiplier of first card by %i and %i respectively',
		Effect.ACTIVATION_TIME.ROUND_START,
		Effect.RESET_TIME.ROUND, # maybe per round?
		card_mult_card_points_and_mult,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.FIRST_CARD,
		1,
		[5, 3],
	),
	'Second breath': Effect.new(
		'Second breath',
		'Play all round again',
		Effect.ACTIVATION_TIME.ROUND_END,
		Effect.RESET_TIME.NONE,
		play_round_again,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.CARD_CURSOR,
		1,
	),
	'Multiplying': Effect.new(
		'Multiplying',
		'Mulitply score at the end of round',
		Effect.ACTIVATION_TIME.ROUND_END,
		Effect.RESET_TIME.ROUND,
		counter_multiply_points_and_multiplier,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.SCORE,
		1,
		[2, 2]
	),
	'Again': Effect.new(
		'Again',
		'Play card again',
		Effect.ACTIVATION_TIME.CARD_END,
		Effect.RESET_TIME.NONE,
		card_play_again,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.CARD_CURSOR,
		1
	),
	'Card power': Effect.new(
		'Card enchancment',
		'Enchance card points and multiplier by %i and %i respectively',
		Effect.ACTIVATION_TIME.CARD_START,
		Effect.RESET_TIME.NONE,
		card_add_points_and_mulitplier,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.SELF_CARD,
		1,
		[1, 0],
	),
	'Card power+': Effect.new(
		'Card enchancment',
		'Enchance card points and multiplier by %i and %i respectively',
		Effect.ACTIVATION_TIME.CARD_START,
		Effect.RESET_TIME.NONE,
		card_add_points_and_mulitplier,
		Effect.TYPE.BUFF,
		Effect.TARGET_TYPE.SELF_CARD,
		1,
		[2, 0],
	),
}

# EFFECT FUNCS

# NOTE: effect func name convetion
# TypeName_ActionName(obj: TypeName)

static func counter_add_points_and_multiplier(
	c: ScoreCounter,
	points: int,
	mult: int
) -> void:
	c.add(points, mult)

static func counter_multiply_points_and_multiplier(
	c: ScoreCounter,
	points: int,
	mult: int
) -> void:
	c.mult(points, mult)

static func card_add_points_and_mulitplier(
	c: Card,
	points: int,
	mult: int
) -> void:
	c.point += points
	c.factor += mult

static func card_play_prev_card(c: Cursor) -> void:
	if c.index < 2: return
	c.move_back(2)

static func card_play_again(c: Cursor) -> void:
	c.move_back()

static func card_mult_card_points_and_mult(
	c: Card,
	p_mult: int,
	m_mult: int
) -> void:
	c.point *= p_mult
	c.factor *= m_mult

static func combo_play_again(c: FullComboView) -> void:
	Game.battle.combo_cursor.move_back()
	Game.battle.card_cursor.set_index(c.first_card.index)

static func play_round_again(c: Cursor) -> void:
	Game.battle.card_cursor.back_to_start()
	Game.battle.combo_cursor.back_to_start()


# CHECK FUNCS
static func check(e: Effect, card_or_combo: Variant) -> bool:
	return e.target == card_or_combo


# UTILS
func get_effect(name: StringName) -> Effect:
	return self.EFFECTS[name].clone()
