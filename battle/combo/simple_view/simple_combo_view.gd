extends Control
class_name SimpleComboView

const MAX_LVL := 2
const ANIMAL := ComboData.ANIMAL
const PATH_TO_ICONS: String = ComboData.PATH_TO_ICONS

@onready var background: TextureRect = $background as TextureRect
@onready var icon: TextureRect = $background/HBoxContainer/icon as TextureRect
@onready var size_lbl: Label = $"background/HBoxContainer/size lbl" as Label

# var combo_data: ComboData = ComboData.new('', '', -1, -1, -1, 0, 0, [], [])

@export var combo_name: String
@export var description: String
@export var price: int

@export var point: int
@export var factor: int

@export var animal: ANIMAL
@export var _material: M.MATERIAL
var upgrade_lvl: int = 1

@export var pattern: Array[Dictionary] = []
@onready var length: int :
	get(): return self.pattern.size()

var effects: Array[Effect] = []


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
func get_drag_preview() -> DragNDropPreview:
	return DragNDropPreview.new(self.duplicate())

func set_combo_data(data: ComboData) -> void:
	self.combo_name = data.name
	self.description = data.description
	self.price = data.price

	self.point = data.point
	self.factor = data.factor

	self.animal = data.animal
	self._material = data.material

	self.pattern = data.pattern
	self.effects = data.effects

# TODO: relace with resources
func get_combo_data() -> ComboData:
	return ComboData.new(
		self.combo_name,
		self.description,
		self.price,
		self.point,
		self.factor,
		self.animal,
		self._material,
		self.pattern,
		self.effects,
	)
	# self.combo_data.effects = self.effects
	# return self.combo_data


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
