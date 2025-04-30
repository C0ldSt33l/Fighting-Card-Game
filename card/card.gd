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
@export var tags: Dictionary


var id: int :
	set(val): self.set_tag_val('id', val)
	get(): return self.get_tag_val('id')
# Short cuts for base tags
var Name: String :
	set(val): self.set_tag_val('Name', val)
	get(): return self.get_tag_val('Name')

#var type: ACTION_TYPE :
	#set(val): self.set_tag_val('type', val)
	#get(): return self.get_tag_val('type')

var Point: int :
	set(val): self.set_tag_val('Point', val)
	get(): return self.get_tag_val('Point')

var Factor: int :
	set(val): self.set_tag_val('Factor', val)
	get(): return self.get_tag_val('Factor')

var dir: DIRECTION :
	set(val): self.set_tag_val('direction', val)
	get(): return self.get_tag_val('direction')

var Price: int:
	set(val):self.set_tag_val('price',val)
	get(): return self.get_tag_val("price") 
# NOTE:
#- Think about func signature(`(dmg: int) -> void` or `() -> int`)
#- When apply (during action or before card spawn) 
# if second case => make copy of it in `BattleArena` class
var Background:Panel

var effects: Array[Callable] = []


signal created(name: String)
signal played(name: String, dealed_dmg: int)
signal destroyed(name: String)


func _ready() -> void:
	Background = get_node("Background")
	self.name_label.text += str(self.Name)
	#self.type_label.text += str(ACTION_TYPE.keys()[self.type])
	self.dmg_label.text += str(self.Point)
	self.created.emit(self.Name + ' has created')


func play() -> void:
	# This is test
	var dmg = self.dmg
	for effect in self.effects:
		dmg += effect.call()

	self.played.emit(self.card_name, dmg)


func add_tags(new_tags: Dictionary) -> void:
	self.tags.merge(new_tags, true)


func has_tag(tag: String) -> bool:
	return self.tags.keys().has(tag)


func get_tag_val(tag: String) -> Variant:
	return self.tags[tag] if self.has_tag(tag) else null


func set_tag_val(tag: String, val: Variant) -> void:
	self.tags[tag] = val


func _exit_tree() -> void:
	self.destroyed.emit(self.Name)
