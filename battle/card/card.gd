extends Node2D
class_name Card

@onready var name_label: Label = $Background/Name as Label
@onready var type_label: Label = $Background/Type as Label
@onready var dmg_label: Label = $Background/DMG as Label


enum BODY_PART {
	HAND,
	LEG,
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
	CHAKRA,
	PRANA,
	KI,
}

var index: int

var card_name: String
var description: String

var point: int
var factor: int
var body_part: BODY_PART
var direction: DIRECTION
var rarity: RARITY = RARITY.REGULAR

#Tags:
# - card_name
# - points
# - type
# - rarity
# - direction
# - martial art
# - has aura
@export var tags: Dictionary = {}

# TODO: add visual effect during changing this field
@export var energy: ENERGY :
	set(val): self.set_tag_val('energy', val)
	get(): return self.get_tag_val('energy')

## `Effect.action` should be func with signatoure `(Card) -> void`
var effects: Array[Effect] = []


func _ready() -> void:
	self.name_label.text += str(self.card_name)
	self.type_label.text += str(BODY_PART.keys()[self.body_part])
	self.dmg_label.text += str(self.point)

	Events.obj_created.emit(self)


# TODO: add animation
func play() -> void:
	self.scale += Vector2(0.2, 0.2)
	# NOTE: maybe do this after card is played
	Game.battle.counter.add(self.point, self.factor)


func add_tags(new_tags: Dictionary) -> void:
	self.tags.merge(new_tags, true)


func has_tag(tag: String) -> bool:
	return self.tags.keys().has(tag)


func get_tag_val(tag: String) -> Variant:
	return self.tags[tag] if self.has_tag(tag) else null


func set_tag_val(tag: String, val: Variant) -> void:
	Events.obj_prop_changed.emit(self, tag, self.get_tag_val(tag), val)
	self.tags[tag] = val


func set_name_label_text(text: String) -> void:
	self.name_label.text = text


func bind_effect(e: Effect) -> void:
	e.bind_to(self)
	self.effects.append(e)


func bind_effect_arr(effs: Array[Effect]) -> void:
	self.effects.append_array(effs)


func _exit_tree() -> void:
	Events.obj_destroyed.emit(self)
