extends Node

var COMBOS: Array[Combo] = [
	Combo.new(
		'Standrat Combo',
		'Started combo',
		15, 10, 2,
		{},
		func()-> void: print('big combo')
	),
	Combo.new(	
		'Big Combo',
		'big Started combo',
		25, 10, 2,
		{},
		func()-> void: print('big combo')
	)
]
