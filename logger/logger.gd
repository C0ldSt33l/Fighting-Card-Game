class_name Logger
extends RichTextLabel 

@export_category('Text Colors')
@export var TEXT_DEFAULT_COLOR := Color.GRAY
@export var TYPE_COLOR := Color.YELLOW
@export var OBJ_NAME_COLOR := Color.WHITE
@export var SCORE_OLD_VAL_COLOR := Color.WHITE
@export var SCORE_NEW_VAL_COLOR := Color.WHITE
@export var SCORE_DIFF_COLOR := Color.GREEN
@export var SCORE_NEGATIVE_DIFF_COLOR := Color.RED
@export var EFFECT_NAME_COLOR := Color.ORANGE
@export var DMG_COLOR := Color.RED

var OBJ_PLACEHOLDER := 'Obj %s type of %s' % [colorful('%s', OBJ_NAME_COLOR), colorful('%s', TYPE_COLOR)]

'''
Possible colorful log elements:
- log type: ?
- obj name: white
- obj type: ? (maybe yellow)
- Score:
	- old val: white
	- new val: white
	- diff: green
	- negative diff: red
- effect name: orange
'''


func _ready() -> void:
	self.bbcode_enabled = true
	self.add_theme_color_override('default_color', TEXT_DEFAULT_COLOR)


func put_text(text: String) -> void:
	self.append_text(text + '\n')


func obj_has_created_log(obj: Variant) -> void:
	var name_and_type := self.get_obj_name_and_type(obj)
	self.put_text((OBJ_PLACEHOLDER + ' has created') % name_and_type) 


func change_points_log(old: int, new: int, diff: int) -> void:
	var diff_color := SCORE_NEGATIVE_DIFF_COLOR if diff < 0 else SCORE_DIFF_COLOR
	var placeholder := 'Score change: points %s -> %s: %s' % [colorful('%d', SCORE_OLD_VAL_COLOR), colorful('%d', SCORE_NEW_VAL_COLOR), colorful('%d', diff_color)]
	self.put_text(placeholder % [old, new, diff])


func change_multiplier_log(old: int, new: int, diff: int) -> void:
	var diff_color := Color.RED if diff < 0 else Color.GREEN
	var placeholder := 'Score change: multiplier %s -> %s: %s' % [colorful('%d', SCORE_OLD_VAL_COLOR), colorful('%d', SCORE_NEW_VAL_COLOR), colorful('%d', diff_color)]
	self.put_text(placeholder % [old, new, diff])


func change_total_score_log(old: int, new: int, diff: int) -> void:
	var diff_color := Color.RED if diff < 0 else Color.GREEN
	var placeholder := 'Score change: total score %s -> %s: %s' % [colorful('%d', SCORE_OLD_VAL_COLOR), colorful('%d', SCORE_NEW_VAL_COLOR), colorful('%d', diff_color)]
	self.put_text(placeholder % [old, new, diff])


func card_has_played_log(card: Card) -> void:
	var placeholder := colorful('Card ', TYPE_COLOR) + colorful('%s', OBJ_NAME_COLOR) + ' has dealt dmg: ' + colorful('%d', DMG_COLOR)
	self.put_text(placeholder % [card.card_name, card.dmg])


func combo_has_activated(combo: Combo) -> void:
	var placeholder := colorful('Combo', TYPE_COLOR) + colorful(' %s ', OBJ_NAME_COLOR) + 'has activated'
	self.put_text(placeholder % [combo.name])


func obj_has_destroyed_log(obj: Variant) -> void:
	var name_and_type := self.get_obj_name_and_type(obj)
	self.put_text((OBJ_PLACEHOLDER + ' has destroyed') % name_and_type)


func get_obj_name_and_type(obj: Variant) -> Array[String]:
	var obj_class: String = obj.get_script().get_global_name()
	var obj_name: String
	match obj_class:
		'Card':
			obj_name = (obj as Card).card_name
		_:
			obj_name = obj.name

	return [obj_name, obj_class]


static func colorful(text: String, c: Color) -> String:
	return '[color=#%s]%s[/color]' % [c.to_html(), text]
