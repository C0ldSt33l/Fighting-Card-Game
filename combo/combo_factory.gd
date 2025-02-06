class_name ComboFactory

# NOTE: Maybe will need to create simple parser for
# combo patterns to expend its variations
static func create(
    name: String,
    cards: Array[Card]
) -> Combo:
    var i := 0
    for card_pattern in Combos.get_combo_patterns(name):
        var card := cards[i]
        for prop in card_pattern:
            if card.get_tag_val(prop) != card_pattern[prop]:
                return null
        i += 1

    var config := Combos.get_combo_config(name).duplicate(true)
    config.erase('patterns')
    return Combo.new(name, cards.slice(0, i), config)
