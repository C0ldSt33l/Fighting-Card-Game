extends Control
class_name Combo

const MAX_LVL := 2
const PATH_TO_ICONS: String = 'res://assets/ui/combo/icons'
enum ANIMAL {
	BULL,
	MANTIS,
	ELEPHENT,
	DRAGON,
	SCORPION,
}

@onready var background: TextureRect = $background as TextureRect
@onready var icon: TextureRect = $background/HBoxContainer/icon as TextureRect
@onready var size_lbl: Label = $"background/HBoxContainer/size lbl" as Label

var idx: int
var pos_idx: float
var pas_stat_idx: int
var pos_end_idx: int

var combo_name: String
var description: String

var price: int
@export var point: int
@export var factor: int

@export var animal: ANIMAL
@export var _material: M.MATERIAL
var upgrade_lvl: int = 1

@export var pattern: Array[Dictionary] = []
var length: int = 0
var cards: Array[Card] = []
var first_card: Card :
	get(): return null if self.cards.size() == 0 else self.cards[0]
var last_card: Card :
	get(): return null if self.cards.size() == 0 else self.cards[-1]

var effects: Array[Effect]


func _ready() -> void:
	self.length = self.pattern.size()
	self.size_lbl.text = str(self.length)
	self.icon.texture = load('%s/%s.png' % [PATH_TO_ICONS, ANIMAL.keys()[self.animal].to_lower()])
	self.background.texture = load('%s/%s.png' % [M.PATH_TO_MATERIALS, M.MATERIAL.keys()[self._material].to_lower()])


func count_card_by_tag(tag: String) -> int:
	var count := 0
	for c in self.cards:
		if c.has_tag(tag):
			count += 1
	return count


func count_card_by_tag_val(tag: String, match: Callable) -> int:
	var count := 0
	for c in self.cards:
		if match.call(c.get_tag_val(tag)):
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


# DRAG N DROP FUNCS
func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(self.get_drag_preview())
	return DragData.new(Game.battle.hand.combo_seqment, self)


func get_drag_preview() -> DragNDropPreview:
	return DragNDropPreview.new(self.duplicate())


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
