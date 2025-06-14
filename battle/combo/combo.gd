extends Control
class_name Combo

const MAX_LVL := 2
@onready var texture_rect: TextureRect = $TextureRect

var idx: int
var pos_idx: float

var combo_name: String
var description: String

var price: int
var point: int
var factor: int

var upgrade_lvl: int = 1

@export var pattern: Array[Dictionary] = []
@onready var length: int = self.pattern.size()
var cards: Array[Card] = []
var first_card: Card :
	get(): return null if self.cards.size() == 0 else self.cards[0]
var last_card: Card :
	get(): return null if self.cards.size() == 0 else self.cards[-1]

var effects: Array[Effect]


func _ready() -> void:
	self.custom_minimum_size.x *= self.length


	#var last_panel := self.panels[-1]
	#var last_panel_stylebox := StyleBoxFlat.new()
	#last_panel_stylebox.bg_color = Color.RED
	#last_panel.add_theme_stylebox_override(
		#'panel',
		#last_panel_stylebox
	#)


func make_default_view() -> void:
	self.texture_rect.scale *= 2


func make_little_view() -> void:
	self.texture_rect.scale /= 2


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
	e.bind_to(self)
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
