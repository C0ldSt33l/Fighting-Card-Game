class_name ComboCard
extends Node2D

static var factory := preload('res://ComboCard/ComboCard.tscn')

@onready var background := $Background as Panel
@onready var name_label := $Background/NameLabel as Label
@onready var desc_label := $Background/DescLabel as Label

var pattern_labels: Array[Label] = [] 


func _ready() -> void:
	self.desc_label.position.y = self.name_label.position.y + self.name_label.size.y
	var pos := self.desc_label.position.y + self.desc_label.size.y
	var panel_height := 0
	for l in self.pattern_labels:
		l.position.y = float(pos)
		pos += l.size.y
		panel_height += l.size.y

	panel_height += self.name_label.size.y + self.desc_label.size.y
	self.background.size.y = panel_height


static func create(parent: Node, name: String, desc: String, patterns: Array[Dictionary]) -> ComboCard:
	var card := factory.instantiate() as ComboCard
	parent.add_child(card)
	card.name_label.text = name
	card.desc_label.text = desc

	var label_temp := Label.new()
	label_temp.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label_temp.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# label_temp.set_anchors_preset(Control.LayoutPreset.PRESET_BOTTOM_WIDE)
	for p in patterns.slice(0, patterns.size() - 1):
		# TODO: make seperate file for label settings
		var pl := label_temp.duplicate() as Label
		pl.text = str(p)
		card.background.add_child(pl)
		var sl := label_temp.duplicate() as Label
		sl.text = '↓'
		card.background.add_child(sl)
		card.pattern_labels.append_array([pl, sl])
	var pl := label_temp.duplicate() as Label
	pl.text = str(patterns[-1])
	card.background.add_child(pl)
	card.pattern_labels.append(pl)

	return card
