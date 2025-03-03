extends Node2D
class_name Card

@onready var name_label := $Background/Name as Label
@onready var type_label := $Background/Type as Label
@onready var dmg_label := $Background/DMG as Label

enum ACTION_TYPE {
	ARM_STRIKE,
	LEG_STRIKE,
}

enum RARITY {
	REGULAR,
	RARE,
	LEGENDARY,
}

enum DIRECTION {
	HEAD,
	BODY,
	LEGS,
}

enum ENERGY {
	PRANA,
	KI,
}

#Tags:
# - card_name
# - points
# - type
# - rarity
# - direction
# - martial art
# - has aura
@export var tags: Dictionary = {}

# Short cuts for base tags
@export var card_name: String :
	set(val): self.set_tag_val('card_name', val.capitalize())
	get(): return self.get_tag_val('card_name')

@export var type: ACTION_TYPE :
	set(val): self.set_tag_val('type', val)
	get(): return self.get_tag_val('type')

@export var points: int = 1:
	set(val): self.set_tag_val('points', val)
	get(): return self.get_tag_val('points')

@export var multiplier: int = 1 :
	set(val): self.set_tag_val('multiplier', val)
	get(): return self.get_tag_val('multiplier')

@export var dir: DIRECTION :
	set(val): self.set_tag_val('direction', val)
	get(): return self.get_tag_val('direction')

@export var rarity: RARITY = RARITY.REGULAR :
	set(val): self.set_tag_val('rarity', val)
	get(): return self.get_tag_val('rarity')

# TODO: add visual effect during changing this field
@export var energy: ENERGY :
	set(val): self.set_tag_val('energy', val)
	get(): return self.get_tag_val('energy')

## `Effect.action` should be func with signatoure `(Card) -> void`
var effects: Array[Effect] = []


signal created(c: Card)
signal played(c: Card)
signal destroyed(c: Card)
signal prop_changed(c: Card, prop: StringName, old: Variant, new: Variant)


func _ready() -> void:
	self.name_label.text += str(self.card_name)
	self.type_label.text += str(ACTION_TYPE.keys()[self.type])
	self.dmg_label.text += str(self.points)
	self.created.emit(self)

	self.rarity = RARITY.REGULAR


func play() -> void:
	print(self.effects)
	self.scale += Vector2(0.2, 0.2)
	for e in self.effects:
		e.activate()

	self.played.emit(self)


func add_tags(new_tags: Dictionary) -> void:
	self.tags.merge(new_tags, true)


func has_tag(tag: String) -> bool:
	return self.tags.keys().has(tag)


func get_tag_val(tag: String) -> Variant:
	return self.tags[tag] if self.has_tag(tag) else null


func set_tag_val(tag: String, val: Variant) -> void:
	self.prop_changed.emit(self, tag, self.get_tag_val(tag), val)
	self.tags[tag] = val


func set_name_label_text(text: String) -> void:
	self.name_label.text = text


func add_effect(e: Effect) -> void:
	self.effects.append(e)


func _exit_tree() -> void:
	self.destroyed.emit(self)
