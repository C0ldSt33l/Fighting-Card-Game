extends Node

var EFFECTS := {
    'Damage+': Effect.new(
        'Damage+',
        'Increase card points by `2`',
        Effect.ACTIVATION_TIME.ROUND_IN_PROGRESS,
        Effect.TYPE.BUFF,
        self.increase_card_points
    ),
    'Multiplier+': Effect.new(
        'Multiplier+',
        'Increase card mulitpier by `1`',
        Effect.ACTIVATION_TIME.ROUND_START,
        Effect.TYPE.BUFF,
        self.increase_card_mult
    ),
    'Double Score': Effect.new(
        'Double Score',
        'Double score',
        Effect.ACTIVATION_TIME.ROUND_END,
        Effect.TYPE.BUFF,
        self.double_score
    ),
}


func increase_card_points(c: Card, bonus: int = 2) -> void:
    c.points += bonus


func increase_card_mult(c: Card, bonus: int = 1) -> void:
    c.multiplier += bonus


func double_score(c: Counter) -> void:
    c.round_score *= 2