extends Control
class_name Card

@onready var background: Panel = $Background as Panel
@onready var name_label: Label = $Background/Name as Label
@onready var type_label: Label = $Background/Type as Label
@onready var dmg_label: Label = $Background/DMG as Label

var is_dragging: bool = false
var is_mouse_inside: bool = false

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
var picture: String

@export var card_name: String
@export var description: String

@export var point: int
@export var factor: int
@export var body_part: BODY_PART
@export var direction: DIRECTION
@export var rarity: RARITY

#Tags:
# - card_name
# - points
# - type
# - rarity
# - direction
# - martial art
# - has aura
@export var tags: Dictionary = {}

# # TODO: add visual effect during changing this field
var energy: ENERGY :
	set(val): self.set_tag_val('energy', val)
	get(): return self.get_tag_val('energy')

## `Effect.action` should be func with signatoure `(Card) -> void`
var effects: Array[Effect] = []


func _ready() -> void:
	self.name_label.text = 'Name: %s' % [self.card_name]
	self.type_label.text = 'Type: %s' % [str(BODY_PART.keys()[self.body_part])]
	self.dmg_label.text = 'Point: %s' % [str(self.point)]

	print('card size: ', self.size)

	Events.obj_created.emit(self)

	
func set_main_prop(
	idx: int,
	conf: Dictionary,
) -> void:
	self.index = idx
	for prop in conf:
		if prop not in ['id', 'Name', 'Price', 'Body part', 'Direction']:
			self[prop.to_snake_case()] = conf[prop]
		else:
			match prop:
				'id':
					self.card_name = str(conf[prop])
				'Body part':
					self.body_part = BODY_PART[conf[prop].to_upper()]
				'Direction':
					self.direction = DIRECTION[conf[prop].to_upper()]
				_:
					pass

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

func _on_mouse_entered() -> void:
	self.is_mouse_inside = true
	self.background


func _on_mouse_exited() -> void:
	self.is_mouse_inside = false


func _on_background_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed('click'):
		pass


func _get_drag_data(at_position: Vector2) -> Variant:
	print('drag working in root node')
	return self


func _to_string() -> String:
	return 'this card'
