extends Control
class_name Combo

const MAX_LVL := 2
@onready var panel_container: HBoxContainer = $PanelContainer as HBoxContainer
var panels: Array[Panel] :
	get():
		var a: Array[Panel]
		a.assign(self.panel_container.get_children())
		return a

var index: int

var combo_name: String
var description: String

var price: int
var point: int
var factor: int

var upgrade_lvl: int = 1

var cards: Array[Card] = []
var first_card: Card :
	get(): return null if self.cards.size() == 0 else self.cards[0]
var last_card: Card :
	get(): return null if self.cards.size() == 0 else self.cards[-1]
@export var length: int = 1

var effects: Array[Effect]


func _init(
	name: String = '',
	conf: Dictionary = {},
	effect: Effect = Effects.get_effect('Feint'),
	cards: Array[Card] = []
) -> void:
	pass


func _ready() -> void:
	if self.length > 1:
		var p: Panel = self.panel_container.get_child(0)
		for i in length - 1:
			self.panel_container.add_child(p.duplicate())
	
	var last_panel := self.panels[-1]
	var last_panel_stylebox := StyleBoxFlat.new()
	last_panel_stylebox.bg_color = Color.RED
	last_panel.add_theme_stylebox_override(
		'panel',
		last_panel_stylebox
	)

	await get_tree().create_timer(1).timeout
	self.scale -= Vector2(0.5, 0.5)


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
