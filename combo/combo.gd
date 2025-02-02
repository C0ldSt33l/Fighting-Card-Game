
class_name Combo

var name: String
var description: String

var price: int
var points: int
var multiplier: int

var pattern: Dictionary
var length: int :
	get():
		return self.pattern.size() 
var cards: Array[Card] = []
var activation_card: Card :
	set(val): return
	get(): return null if self.cards.size() == 0 else self.cards[-1]

# NOTE: Maybe need to make it as seperate class `Effect`
var effect: Callable


signal created(c: Combo)
signal played(c: Combo)
signal destroyed(c: Combo)



func _init(
	name: String,
	description: String,
	price: int,
	points: int,
	multiplier: int,
	pattern: Dictionary,
	effect: Callable
) -> void:
	self.name = name
	self.description = description
	self.price = price
	self.points = points
	self.multiplier = multiplier
	self.pattern = pattern
	self.effect = effect


# NOTE: Maybe will need to create simple parser for combo pattern
# to expend its variations
func check(cards: Array[Card]) -> bool:
	var i := 0
	for prop in self.pattern:
		if cards[i] == null: return false
		if cards[i][prop] != self.pattern[prop]:
			return false
		i += 1

	self.cards = cards.slice(0, i)
	return true
	

# NOTE: which signature is more suitable:
	# - (score: int, multiply: int) -> void
	# - (score: Vector2i) -> void
	# - (cards: Array[Card], cur_pos: int) -> void
	# - (score: Vector2i, cards: Array[Card], cur_pos: int) -> void
func apply_effect() -> void:
	self.effect.call()


func count_card_by_tag(tag: String, val, match: Callable) -> int:
	var count := 0
	for c in self.cards:
		if !match.call(val, c.get_tag_val(tag)): continue
		count += 1
	return count


# Maybe will come in useful for creating combo pattern
static func equal(target, cur) -> bool:
	return target == cur


static func greater(target, cur) -> bool:
	return cur > target


static func less(target, cur) -> bool:
	return cur < target


static func greate_or_equal(target, cur) -> bool:
	return cur == target or cur > target


static func less_or_equal(target, cur) -> bool:
	return cur == target or cur < target
