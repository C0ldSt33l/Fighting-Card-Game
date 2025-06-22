class_name Constrains

static func without_rerell() -> void:
    Game.battle.reroll_count = 0


static func one_round() -> void:
    Game.battle.round_count = 1


# WARNING: damage decrease may stacks between battles
static func weakness() -> void:
    PlayerConfig.extra_damage -= 1