extends Node

var EFFECTS := {
    'Damage+': Effect.new(
        'Damage+',
        'Increase card points by `2`',
        Effect.ACTIVATION_TIME.BEFORE_CARD_PLAYED,
        Effect.TYPE.BUFF,
        func(c: Card) -> void: \
            c.points += 2
    ),
    'Multiplier+': Effect.new(
        'Multiplier+',
        'Increase card mulitpier by 1',
        Effect.ACTIVATION_TIME.BEFORE_CARD_PLAYED,
        Effect.TYPE.BUFF,
        func(c: Card) -> void: \
            c.multiplier += 1
    ),
}