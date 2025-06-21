extends Control
class_name Table

var card_place_count: int = 6 #PlayerConfig.hand_size / 2
@onready var card_places_container: HBoxContainer = $VBoxContainer/PanelContainer/MarginContainer/CardPlaces as HBoxContainer
var card_places: Array[CardPlace] :
	get():
		var a: Array[CardPlace]
		a.assign(self.card_places_container.get_children())
		return a
var cards: Array[Card] :
	get = get_cards

@onready var combo_places_container: HBoxContainer = $VBoxContainer/MarginContainer/ComboPlaces as HBoxContainer
var combo_places: Array[ComboPlace] :
	get():
		var a: Array[ComboPlace]
		a.assign(self.combo_places_container.get_children())
		return a
var combos: Array[FullComboView] :
	get = get_combos

var CARD_PLACE_TEMPLATE: CardPlace = preload("res://battle/ui/table/card place/card_place.tscn").instantiate() as CardPlace
var COMBO_PLACE_TEMPLATE: ComboPlace = preload("res://battle/ui/table/combo place/combo_place.tscn").instantiate() as ComboPlace


func _ready() -> void:
	self.__setup_card_places()
	self.__setup_combo_places()


func __setup_card_places() -> void:
	for i in self.card_place_count:
		Utils.Factory.create_with_binding(
			self.card_places_container,
			CARD_PLACE_TEMPLATE,
			func (p: CardPlace):
				p.index = i
		)


func __setup_combo_places() -> void:
	self.__setup_combo_place_container()
	var combo_idxs: Array[float] = [0]
	for i in range(1, self.card_place_count):
		combo_idxs.append(i - 0.5)
		combo_idxs.append(i)

	for idx in combo_idxs:
		Utils.Factory.create_with_binding(
			self.combo_places_container,
			COMBO_PLACE_TEMPLATE,
			func (p: ComboPlace):
				p.index = idx
		)


func __setup_combo_place_container() -> void:
	self.combo_places_container.add_theme_constant_override(
		'separation',
		self.card_places_container.get_theme_constant('separation') / 2
	)
	$VBoxContainer/MarginContainer.add_theme_constant_override(
		'margin_left',
		$VBoxContainer/PanelContainer/MarginContainer
			.get_theme_constant('margin_left') + self.card_places[0].size.x / 4
	)
	

func get_cards() -> Array[Card]:
	var cards: Array[Card]
	for p in self.card_places:
		var c := p.card
		if c:
			cards.append(c)
	return cards


func remove_cards() -> void:
	for p in self.card_places:
		p.remove_card()


func get_combos() -> Array[FullComboView]:
	var combos: Array[FullComboView]
	for p in self.combo_places:
		var c := p.combo
		if c:
			combos.append(c)
	return combos


func remove_combos() -> void:
	for p in self.combo_places:
		p.remove_combo()
