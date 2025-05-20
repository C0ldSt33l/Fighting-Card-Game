extends Node

var COMBOS := {
	'Standart Combo':
	{
		'props': {
			'description': 'Started combo',
			'price': 15,
			'points': 10,
			'factor': 2,
		},
		'patterns':
		[
			{ 'card_name': 'kick' },
			{ 'type': Card.BODY_PART.LEG },
		],
		'effect': 'Multiplier+'
	},
	# 'Big Combo':
	# {
	# 	'props': {
	# 		'description': 'big Started combo',
	# 		'price': 25,
	# 		'points': 10,
	# 		'factor': 2,
	# 	},
	# 	'patterns':
	# 	[
	# 		{ 'card_name': 'fist' },
	# 		{ 'card_name': 'knee strike' },
	# 		{ 'card_name': 'elbow' },
	# 	],
	# 	'effect': 'Card enchancment'
	# }
}


func get_combo_props(name: String) -> Dictionary:
	return self.COMBOS[name]['props']


func get_combo_patterns(name: String) -> Array[Dictionary]:
	var patterns: Array[Dictionary]
	patterns.assign(self.COMBOS[name]['patterns'])
	return patterns


func get_combo_effect(name: String) -> Effect:
	var effect_name := self.COMBOS[name]['effect'] as String
	return Effects.EFFECTS[effect_name].clone()
