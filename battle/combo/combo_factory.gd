class_name ComboFactory

# NOTE: Maybe will need to create simple parser for
# combo patterns to expend its variations
static func create(
	name: String,
	cards: Array[Card]
) -> Combo:
	var i := 0
	var patterns := Combos.get_combo_patterns(name)
	if cards.size() < patterns.size(): return null
	for card_pattern in patterns:
		var card := cards[i]
		for prop in card_pattern:
			if card.get_tag_val(prop) != card_pattern[prop]:
				return null
		i += 1

	var config := Combos.get_combo_props(name).duplicate()
	var effect := Combos.get_combo_effect(name).clone()
	return Combo.new(name, config, effect, cards.slice(0, i))
