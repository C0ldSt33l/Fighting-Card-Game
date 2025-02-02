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

#Tags:
# - card_name
# - dmg
# - type
# - rarity
# - direction
# - martial art
# - has aura
@export var tags: Dictionary = {}

# Short cuts for base tags
@export var card_name: String :
	set(val): self.set_tag_val('card_name', val)
	get(): return self.get_tag_val('card_name')

@export var type: ACTION_TYPE :
	set(val): self.set_tag_val('type', val)
	get(): return self.get_tag_val('type')

@export var dmg: int :
	set(val): self.set_tag_val('dmg', val)
	get(): return self.get_tag_val('dmg')

@export var dir: DIRECTION :
	set(val): self.set_tag_val('direction', val)
	get(): return self.get_tag_val('direction')

@export var rarity: RARITY :
	set(val): self.set_tag_val('rarity', val)
	get(): return self.get_tag_val('rarity')

# NOTE:
#- Think about func signature(`(dmg: int) -> void` or `() -> int`)
#- When apply (during action or before card spawn) 
# if second case => make copy of it in `BattleArena` class
var effects: Array[Callable] = []


signal created(c: Card)
signal played(c: Card)
signal destroyed(c: Card)


func _ready() -> void:
	self.name_label.text += str(self.card_name)
	self.type_label.text += str(ACTION_TYPE.keys()[self.type])
	self.dmg_label.text += str(self.dmg)
	self.created.emit(self)


func play() -> void:
	# This is test
	var dmg = self.dmg
	for effect in self.effects:
		dmg += effect.call()

	self.played.emit(self)


func add_tags(new_tags: Dictionary) -> void:
	self.tags.merge(new_tags, true)


func has_tag(tag: String) -> bool:
	return self.tags.keys().has(tag)


func get_tag_val(tag: String) -> Variant:
	return self.tags[tag] if self.has_tag(tag) else null


func set_tag_val(tag: String, val: Variant) -> void:
	self.tags[tag] = val


func _exit_tree() -> void:
	self.destroyed.emit(self)
