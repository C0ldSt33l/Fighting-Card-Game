extends Node

const ANIMAL := ComboData.ANIMAL

const COMBOS := {
	'Standart Combo': {
		'props': {
			'description': 'Started combo',
			'animal': ANIMAL.BULL,
			'price': 15,
			'point': 10,
			'factor': 2,
		},
		'pattern': [
			{ 'body part': Card.BODY_PART.LEG },
			{ 'body part': Card.BODY_PART.HAND },
		],
		'effect': 'Multiplying'
	},
	'Big Combo': {
		'props': {
			'description': 'big Started combo',
			'animal': ANIMAL.ELEPHENT,
			'price': 25,
			'point': 10,
			'factor': 2,
		},
		'pattern': [
			{ 'name': 'fist' },
			{ 'name': 'knee strike' },
			{ 'name': 'elbow' },
		],
		'effect': 'Card enchancment'
	},
	'Shord combo': {
		'props': {
			'description': 'Made of one card',
			'animal': ANIMAL.SCORPION,
			'price': 5,
			'point': 5,
			'factor': 1,
		},
		'pattern': [
			{ 'name': 'kick' },
			# { 'body part': Card.BODY_PART.HAND },
		],
		'effect': 'First strike'
	},
}


func get_combo_props(name: String) -> Dictionary:
	return self.COMBOS[name]['props']


func get_combo_pattern(name: String) -> Array[Dictionary]:
	var patterns: Array[Dictionary]
	patterns.assign(self.COMBOS[name]['pattern'])
	return patterns


func get_combo_effect(name: String) -> Effect:
	var effect_name := self.COMBOS[name]['effect'] as String
	return Effects.get_effect(effect_name)
