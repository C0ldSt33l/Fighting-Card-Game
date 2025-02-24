class_name Logger
extends RichTextLabel 

@export_category('Text Colors')
@export var TEXT_DEFAULT_COLOR := Color.GRAY
@export var OBJ_TYPE_COLOR := Color.YELLOW
@export var OBJ_NAME_COLOR := Color.WHITE
@export var SCORE_OLD_VAL_COLOR := Color.WHITE
@export var SCORE_NEW_VAL_COLOR := Color.WHITE
@export var SCORE_DIFF_COLOR := Color.GREEN
@export var SCORE_NEGATIVE_DIFF_COLOR := Color.RED
@export var EFFECT_NAME_COLOR := Color.ORANGE
@export var DMG_COLOR := Color.RED

const OBJ_PLACEHOLDER := "%s '%s'"
const OBJ_HAS_CREATED_PLACEHOLDER := OBJ_PLACEHOLDER + ' has created'
const OBJ_HAS_DESTROYED_PLACEHOLDER := OBJ_PLACEHOLDER + ' has destroyed'

const CARD_HAS_PLAYED_PLACEHOLDER := "%s '%s' has played with score(%s, %s)"
const COMBO_HAS_ACTIVATED_PLACEHOLDER := "%s '%s' has activated with effects:"
const APPLYED_EFFECT_PLACEHOLDER := '%s'

const NUMBER_CHANGE_PLACEHOLDER := '%s -> %s: %s'
const SCORE_POINTS_CHANGE_PLACEHOLDER := 'Score: points ' + NUMBER_CHANGE_PLACEHOLDER
const SCORE_MULTIPLIER_CHANGE_PLACEHOLDER := 'Score: multiplier ' + NUMBER_CHANGE_PLACEHOLDER
const SCORE_TOTAL_SCORE_CHANGE_PLACEHOLDER := 'Score: total score ' + NUMBER_CHANGE_PLACEHOLDER

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
	var type_and_name := self.get_obj_type_and_name(obj)
	self.put_text(OBJ_HAS_CREATED_PLACEHOLDER % [
		colorful(type_and_name[0], OBJ_TYPE_COLOR),
		colorful(type_and_name[1], OBJ_NAME_COLOR),
	]) 


func change_points_log(old: int, new: int, diff: int) -> void:
	var diff_color := SCORE_NEGATIVE_DIFF_COLOR if diff < 0 else SCORE_DIFF_COLOR
	self.put_text(SCORE_POINTS_CHANGE_PLACEHOLDER % [
		colorful(str(old), SCORE_OLD_VAL_COLOR),
		colorful(str(new), SCORE_NEW_VAL_COLOR),
		colorful(str(diff), diff_color),
	])


func change_multiplier_log(old: int, new: int, diff: int) -> void:
	var diff_color := SCORE_NEGATIVE_DIFF_COLOR if diff < 0 else SCORE_DIFF_COLOR
	self.put_text(SCORE_MULTIPLIER_CHANGE_PLACEHOLDER % [
		colorful(str(old), SCORE_OLD_VAL_COLOR),
		colorful(str(new), SCORE_NEW_VAL_COLOR),
		colorful(str(diff), diff_color),
	])


func change_total_score_log(old: int, new: int, diff: int) -> void:
	var diff_color := SCORE_NEGATIVE_DIFF_COLOR if diff < 0 else SCORE_DIFF_COLOR
	self.put_text(SCORE_TOTAL_SCORE_CHANGE_PLACEHOLDER % [
		colorful(str(old), SCORE_OLD_VAL_COLOR),
		colorful(str(new), SCORE_NEW_VAL_COLOR),
		colorful(str(diff), diff_color),
	])


func card_has_played_log(c: Card) -> void:
	var type_and_name := self.get_obj_type_and_name(c)
	self.put_text(CARD_HAS_PLAYED_PLACEHOLDER % [
		colorful(type_and_name[0], OBJ_TYPE_COLOR),
		colorful(type_and_name[1], OBJ_NAME_COLOR),
		colorful(str(c.points), DMG_COLOR),
		colorful(str(c.multiplier), DMG_COLOR),
	])
	self.put_text('Effects:')
	for e in c.effects:
		self.put_text('\t' + (APPLYED_EFFECT_PLACEHOLDER % [colorful(e.name, EFFECT_NAME_COLOR)]))


func combo_has_activated(c: Combo) -> void:
	var type_and_name := self.get_obj_type_and_name(c)
	self.put_text(COMBO_HAS_ACTIVATED_PLACEHOLDER % [
		colorful(type_and_name[0], OBJ_TYPE_COLOR),
		colorful(type_and_name[1], OBJ_NAME_COLOR),
	])
	self.put_text(('Main ' + APPLYED_EFFECT_PLACEHOLDER) % [colorful(c.effect.name, EFFECT_NAME_COLOR)])
	for e in c.effects_from_upgrades:
		self.put_text(APPLYED_EFFECT_PLACEHOLDER % [colorful(e.name, EFFECT_NAME_COLOR)])


func obj_has_destroyed_log(obj: Variant) -> void:
	var type_and_name := self.get_obj_type_and_name(obj)
	self.put_text(OBJ_HAS_DESTROYED_PLACEHOLDER % [
		colorful(type_and_name[0], OBJ_TYPE_COLOR),
		colorful(type_and_name[1], OBJ_NAME_COLOR),
	])


func get_obj_type_and_name(obj: Variant) -> Array[String]:
	var obj_type: String = obj.get_script().get_global_name()
	var obj_name: String
	match obj_type:
		'Card':
			obj_name = (obj as Card).card_name
		_:
			obj_name = obj.name

	var type_and_name: Array[String] = [obj_type, obj_name]
	return type_and_name


static func colorful(text: String, c: Color) -> String:
	return '[color=#%s]%s[/color]' % [c.to_html(), text]
