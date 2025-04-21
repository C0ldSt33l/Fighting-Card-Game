class_name Combo

const MAX_LVL := 2

var name: String
var description: String

var price: int
var points: int
var multiplier: int

var upgrade_lvl := 1

var cards: Array[Card] = []
var start_card: Card :
	set(val): return
	get(): return null if self.cards.size() == 0 else self.cards[0]
var end_card: Card :
	set(val): return
	get(): return null if self.cards.size() == 0 else self.cards[-1]
var length: int :
	set(val): return
	get(): return self.cards.size()

var effects: Array[Effect]


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
	self.cards.append_array(cards)
	if effect.target_type == Effect.TARGET_TYPE.BATTLE_CARD:
		for c in cards:
			var e := effect.clone()
			e.set_target(c)
			self.bind_effect(e)
	else:
		# BUG: will cause error if target is not set
		self.bind_effect(effect)

	Events.obj_created.emit(self)


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


func bind_effect(e: Effect) -> void:
	self.effects.append(e)


func bind_effect_arr(effs: Array[Effect]) -> void:
	self.effects.append_array(effs)


func reset_effects() -> void:
	pass


func is_all_effects_activated() -> bool:
	return self.effects.is_empty()


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
