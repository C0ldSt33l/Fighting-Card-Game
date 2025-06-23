class_name ComboData

const PATH_TO_ICONS: String = 'res://assets/ui/combo/icons'
enum ANIMAL {
	BULL,
	MANTIS,
	ELEPHENT,
	DRAGON,
	SCORPION,
}

var name: String
var description: String
var price: int

var point: int
var factor: int

var animal: ANIMAL
var material: M.MATERIAL

var pattern: Array[Dictionary]
var length: int :
	get(): return self.pattern.size()

var cards: Array[Card]
var first_card: Card :
	get(): return self.cards[0]
var last_card: Card :
	get(): return self.cards[-1]


var effects: Array[Effect]
var tags: Array[Dictionary]


func _init(
	name: String,
	description: String,
	price: int,
	point: int,
	factor: int,
	animal: ANIMAL,
	material: M.MATERIAL,
	pattern: Array[Dictionary],
	effectrs: Array[Effect],
	cards: Array[Card] = [],
) -> void:
	self.name = name
	self.description = description
	self.price =- price

	self.point = point
	self.factor = factor

	self.animal = animal
	self.material = material

	self.pattern = pattern
	self.effects = effectrs
	
	self.cards = cards

func check_cards(cards: Array[Card]) -> bool:
	print('COMBO PATTERN in data: ', self.pattern)
	print('cards: ', cards.size())
	print('lenght: ', self.length)
	print('pattern size: ', self.pattern.size())
	if cards.size() != self.length:
		return false
	
	for i in len(cards):
		var c := cards[i]
		var t := self.pattern[i]
		var tn: String = t.keys()[0]
		var tv = t.values()[0]
		print('TAG: ', t)
		if not c.has_tag(tn) or c.get_tag_val(tn) != tv:
			return false
	
	return true
