extends Control
class_name Card

@onready var background: TextureRect = $Background as TextureRect
@onready var point_lbl: Label = $"Background/MarginContainer/VBoxContainer/point lbl" as Label
@onready var body_part_icon: TextureRect = $"Background/MarginContainer/VBoxContainer/body part icon" as TextureRect


const PATH_TO_ICONS: String = 'res://assets/ui/card/icons'
enum BODY_PART {
	HAND,
	LEG,
	HEAD,
	THENAR,
	KNEE,
	ELBOW,
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

var index: int = -1

@export var card_name: String
@export var description: String

@export var point: int
@export var factor: int
@export var _material: M.MATERIAL
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
	self.body_part_icon.texture = load('%s/%s.png' % [PATH_TO_ICONS, BODY_PART.keys()[self.body_part].to_lower()])
	self.background.texture = load('%s/%s.png' % [M.PATH_TO_MATERIALS, M.MATERIAL.keys()[self._material]])
	self.point_lbl.text = str(self.point)

	Events.obj_created.emit(self)

	
func set_main_props(
	conf: Dictionary,
) -> void:
	for prop in conf:
		if prop not in ['id', 'Name', 'Price', 'Body part', 'Direction', 'Point', 'Picture']:
			self[prop.to_snake_case()] = conf[prop]
		else:
			match prop:
				'Name':
					self.card_name = conf[prop]
				'Body part':
					self.body_part = BODY_PART[conf[prop].to_upper()]
				'Direction':
					self.direction = DIRECTION[conf[prop].to_upper()]
				'Point':
					self.point = randi_range(1, 9)
					#self.dmg_label.text = 'Point: %s' % [self.point]
				_:
					pass

# TODO: add animation
func play() -> void:
	self.scale += Vector2(0.2, 0.2)
	# NOTE: maybe do this after card is played
	Game.battle.score_counter.add(self.point, self.factor)


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


func get_drag_preview() -> DragNDropPreview:
	return DragNDropPreview.new(self.duplicate())


func _exit_tree() -> void:
	Events.obj_destroyed.emit(self)
