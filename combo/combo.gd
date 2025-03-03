class_name Combo

const MAX_LVL := 2

var name: String
var description: String

var price: int
var points: int
var multiplier: int

var upgrade_lvl := 1

var cards: Array[Card] = []
var first_card: Card :
	set(val): return
	get(): return null if self.cards.size() == 0 else self.cards[0]
var last_card: Card :
	set(val): return
	get(): return null if self.cards.size() == 0 else self.cards[-1]
var length: int :
	set(val): return
	get(): return self.cards.size()

var effect: Effect = null
var effects_from_upgrades: Array[Effect] = []


signal created(c: Combo)
signal played(c: Combo)
signal destroyed(c: Combo)


func _init(
	name: String,
	props: Dictionary,
	effect: Effect,
	cards: Array[Card],
) -> void:
	self.name = name
	for p in props:
		self[p] = props[p]
	effect.bind_to(self)
	self.effect = effect 
	self.cards.append_array(cards)

	self.created.emit(self)


func apply_effect() -> void:
	for c in self.cards:
		var e := self.effect.clone()
		e.set_target(c)
	self.played.emit(self)


func count_card_by_tag(tag: String) -> int:
	var count := 0
	for c in self.cards:
		if !c.has_tag(tag): continue
		count += 1
	return count


func count_card_by_tag_val(tag: String, match: Callable) -> int:
	var count := 0
	for c in self.cards:
		if !match.call(c.get_tag_val(tag)): continue
		count += 1
	return count


func upgrade(e: Effect) -> void:
	if self.upgrade_lvl + 1 > self.MAX_LVL: return
	self.upgrade_lvl += 1
	self.effects_from_upgrades.append(e)


# Maybe will come in useful for creating combo patterns
static func equal(target, cur) -> bool:
	return target == cur


static func greater(target, cur) -> bool:
	return cur > target


static func less(target, cur) -> bool:
	return cur < target


static func greater_or_equal(target, cur) -> bool:
	return cur == target or cur > target


static func less_or_equal(target, cur) -> bool:
	return cur == target or cur < target
