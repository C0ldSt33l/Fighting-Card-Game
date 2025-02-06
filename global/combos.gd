extends Node

var COMBOS := {
	'Standart Combo':
	{
		'description': 'Started combo',
		'price': 15,
		'points': 10,
		'multiplier': 2,
		'patterns':
		[
			{ 'card_name': 'kick' },
			{ 'type': Card.ACTION_TYPE.LEG_STRIKE },
		],
		'effect': func()-> void: print('big combo')
	},
	'Big Combo':
	{
		'description': 'big Started combo',
		'price': 25,
		'points': 10,
		'multiplier': 2,
		'patterns':
		[
			{ 'card_name': 'fist' },
			{ 'card_name': 'knee strike' },
			{ 'card_name': 'elbow' },
		],
		'effect': func()-> void: print('big combo')
	}
}


func get_combo_config(name: String) -> Dictionary:
	return self.COMBOS[name]


func get_combo_patterns(name: String) -> Array[Dictionary]:
	var patterns: Array[Dictionary]
	patterns.assign(self.COMBOS[name]['patterns'])
	return patterns
