
class_name Combo

# TODO: remake combo config and combo creation in test scene

var name: String
var description: String

var price: int
var points: int
var multiplier: int

# # TODO: think about another names
# var patterns: Array[Dictionary] 
# var length: int :
# 	set(val): return
# 	get(): return self.patterns.size() 
var cards: Array[Card] = []
# BUG: always return `null`
var activation_card: Card :
	set(val): return
	get(): return null if self.cards.size() == 0 else self.cards[-1]
var lenght: int :
	set(val): return
	get(): return self.cards.size()

# TODO: Maybe need to make it as seperate class `Effect`
var effect: Callable


signal created(c: Combo)
signal played(c: Combo)
signal destroyed(c: Combo)


func _init(
	name: String,
	cards: Array[Card],
	config: Dictionary,
) -> void:
	self.name = name
	self.cards = cards
	for prop in config:
		self[prop] = config[prop]

	self.created.emit(self)


# TODO: which signature is more suitable:
# - (score: int, multiply: int) -> void
# - (score: Vector2i) -> void
# - (cards: Array[Card], cur_pos: int) -> void
# - (score: Vector2i, cards: Array[Card], cur_pos: int) -> void
func apply_effect() -> void:
	self.effect.call()
	self.played.emit(self)


func count_card_by_tag(tag: String, val, match: Callable) -> int:
	var count := 0
	for c in self.cards:
		if !match.call(val, c.get_tag_val(tag)): continue
		count += 1
	return count


# Maybe will come in useful for creating combo patterns
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


func _exit_tree() -> void:
	self.destroyed.emit(self)
