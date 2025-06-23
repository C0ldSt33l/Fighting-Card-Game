extends Control
class_name FullComboView

const PATH_TO_SIZE_2: String = "res://assets/ui/combo/size-2"
const PATH_TO_SIZE_3: String = "res://assets/ui/combo/size-3"
const PATH_TO_ICONS: String = ComboData.PATH_TO_ICONS
const ANIMAL := ComboData.ANIMAL

@onready var panel: TextureRect = $panel as TextureRect
@onready var icon: TextureRect = $panel/icon as TextureRect

var index: int
var pos_idx: float

@export var combo_name: String
@export var description: String
@export var price: int

@export var point: int
@export var factor: int

@export var animal: ANIMAL
@export var _material: M.MATERIAL

@export var pattern: Array[Dictionary] = []
@onready var length: int :
	get(): return self.pattern.size()
@export var cards: Array[Card] = []
var first_card: Card :
	get(): return null if self.cards.size() == 0 else self.cards[0]
var last_card: Card :
	get(): return null if self.cards.size() == 0 else self.cards[-1]

var effects: Array[Effect] = []



func _ready() -> void:
	var texture_path := PATH_TO_SIZE_2 if self.length == 2 else PATH_TO_SIZE_3
	self.icon.texture = load('%s/%s.png' % [PATH_TO_ICONS, ANIMAL.keys()[self.animal].to_lower()])
	self.panel.texture = load('%s/combo_%s_%s.png' % [texture_path, self.length, M.MATERIAL.keys()[self._material].to_lower()])
	self.icon.position.x = self.panel.texture.get_size().x / 2 - self.icon.size.x / 2


func get_drag_preview() -> DragNDropPreview:
	return DragNDropPreview.new(self.panel.duplicate())

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
		self.cards,
	)
