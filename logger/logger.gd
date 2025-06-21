class_name Logger
extends RichTextLabel 

@export_category('Text Colors')
@export var TEXT_DEFAULT_COLOR := Color.GRAY
@export var OBJ_TYPE_COLOR := Color.YELLOW
@export var OBJ_NAME_COLOR := Color.WHITE
@export var OBJ_PROP_COLOR := Color.WHITE
@export var SCORE_OLD_VAL_COLOR := Color.WHITE
@export var SCORE_NEW_VAL_COLOR := Color.WHITE
@export var SCORE_DIFF_COLOR := Color.GREEN
@export var SCORE_NEGATIVE_DIFF_COLOR := Color.RED
@export var EFFECT_NAME_COLOR := Color.ORANGE
@export var DMG_COLOR := Color.RED

const BATTLE_STARTED_PLACEHOLDER := '---BATTLE START---'
const BATTLE_ENDED_PLACEHOLDER := '---BATTLE END---'

const ROUND_PREPARATION_STARTED_PLACEHOLDERA := '---ROUND PREPARATION---'
const ROUND_STARTED_PLACEHOLDER := '---ROUND START---'
const ROUND_ENDED_PLACEHOLDER := '---ROUND END---'
const ROUND_EXIT_PLACEHOLDER := '---ROUND EXIT---'

const OBJ_PLACEHOLDER := "%s '%s'"
const OBJ_CREATED_PLACEHOLDER := OBJ_PLACEHOLDER + ' created'
const OBJ_DESTROYED_PLACEHOLDER := OBJ_PLACEHOLDER + ' destroyed'
const OBJ_PROP_CHANGE_PLACEHOLDER := '%s.%s changed: %s -> %s'

const CARD_STARTED_PLACEHOLDER := OBJ_PLACEHOLDER + " started with score(%s, %s)"
const CARD_ENDED_PLACEHOLDER := OBJ_PLACEHOLDER + ' ended'

const COMBO_STARTED_PLACEHOLDER := OBJ_PLACEHOLDER + ' started with score(%s, %s)'
const COMBO_ENDED_PLACEHOLDER := OBJ_PLACEHOLDER + ' ended'

const EXIT_FROM_PLACEHOLDER := 'Exit from ' + OBJ_PLACEHOLDER

const EFFECT_APPLYED_PLACEHOLDER:= OBJ_PLACEHOLDER + ' applyed to ' + OBJ_PLACEHOLDER + ' by ' + OBJ_PLACEHOLDER
const EFFECT_ACTIVATED_PLACEHOLDER := OBJ_PLACEHOLDER + ' activated on ' + OBJ_PLACEHOLDER

const NUMBER_CHANGE_PLACEHOLDER := '%s -> %s: %s'
const SCORE_POINTS_CHANGE_PLACEHOLDER := 'Score: points ' + NUMBER_CHANGE_PLACEHOLDER
const SCORE_FACTOR_CHANGE_PLACEHOLDER := 'Score: factor ' + NUMBER_CHANGE_PLACEHOLDER
const SCORE_TOTAL_SCORE_CHANGE_PLACEHOLDER := 'Score: total score ' + NUMBER_CHANGE_PLACEHOLDER

'''
Possible Utils.colorful log elements:
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

#
#func _ready() -> void:
	#self.bbcode_enabled = true
	#self.add_theme_color_override('default_color', TEXT_DEFAULT_COLOR)
	#self.connect_battle_signals()
#
#
#func put_text(text: String) -> void:
	#self.append_text(text + '\n')
#
#
#func obj_created_log(obj: Variant) -> void:
	#var type_and_name := self.get_obj_type_and_name(obj)
	#self.put_text(OBJ_CREATED_PLACEHOLDER % [
		#Utils.colorful(type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(type_and_name[1], OBJ_NAME_COLOR),
	#]) 
#
#func obj_has_destroyed_log(obj: Variant) -> void:
	#var type_and_name := self.get_obj_type_and_name(obj)
	#self.put_text(OBJ_DESTROYED_PLACEHOLDER % [
		#Utils.colorful(type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(type_and_name[1], OBJ_NAME_COLOR),
	#])
#
#func obj_prop_changed_log(obj: Variant, prop: StringName, old: Variant, new: Variant) -> void:
	#var type := self.get_obj_type_and_name(obj)[0]
	#self.put_text(OBJ_PROP_CHANGE_PLACEHOLDER % [
		#Utils.colorful(type, OBJ_TYPE_COLOR),
		#Utils.colorful(prop, Color.WHITE),
		#Utils.colorful(str(old), SCORE_OLD_VAL_COLOR),
		#Utils.colorful(str(new), SCORE_NEW_VAL_COLOR),
	#])
#
#
#func battle_started_log():
	#self.put_text(Utils.colorful(BATTLE_STARTED_PLACEHOLDER, Color.WHITE))
#
#func battle_ended_log():
	#self.put_text(Utils.colorful(BATTLE_ENDED_PLACEHOLDER, Color.WHITE))
#
#
#func round_preparation_started_log():
	#self.put_text(ROUND_PREPARATION_STARTED_PLACEHOLDERA)
#
#func round_started_log():
	#self.put_text(ROUND_STARTED_PLACEHOLDER)
#
#func round_ended_log():
	#self.put_text(ROUND_ENDED_PLACEHOLDER)
#
#func round_exit_log():
	#self.put_text(ROUND_EXIT_PLACEHOLDER)
#
#
#func card_started_log(c: Card) -> void:
	#var type_and_name := self.get_obj_type_and_name(c)
	#self.put_text(CARD_STARTED_PLACEHOLDER % [
		#Utils.colorful(type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(type_and_name[1], OBJ_NAME_COLOR),
		#Utils.colorful(str(c.point), OBJ_PROP_COLOR),
		#Utils.colorful(str(c.factor), OBJ_PROP_COLOR),
	#])
#
#func card_ended_log(c: Card) -> void:
	#var type_and_name := self.get_obj_type_and_name(c)
	#self.put_text(CARD_ENDED_PLACEHOLDER % [
		#Utils.colorful(type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(type_and_name[1], OBJ_NAME_COLOR),
	#])
#
#func card_exit_log(c: Card) -> void:
	#var type_and_name := self.get_obj_type_and_name(c)
	#self.put_text(EXIT_FROM_PLACEHOLDER % [
		#Utils.colorful(type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(type_and_name[1], OBJ_NAME_COLOR),
	#])
#
#
#func combo_started_log(c: Combo) -> void:
	#var type_and_name := self.get_obj_type_and_name(c)
	#self.put_text(COMBO_STARTED_PLACEHOLDER % [
		#Utils.colorful(type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(type_and_name[1], OBJ_NAME_COLOR),
		#Utils.colorful(str(c.point), OBJ_PROP_COLOR),
		#Utils.colorful(str(c.factor), OBJ_PROP_COLOR),
	#])
#
#func combo_ended_log(c: Combo) -> void:
	#var type_and_name := self.get_obj_type_and_name(c)
	#self.put_text(COMBO_ENDED_PLACEHOLDER % [
		#Utils.colorful(type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(type_and_name[1], OBJ_NAME_COLOR),
	#])
#
#func combo_exit_log(c: Combo) -> void:
	#var type_and_name := self.get_obj_type_and_name(c)
	#self.put_text(EXIT_FROM_PLACEHOLDER % [
		#Utils.colorful(type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(type_and_name[1], OBJ_NAME_COLOR),
	#])
#
#
#func effect_applyed_log(e: Effect) -> void:
	#var effect_type_and_name := self.get_obj_type_and_name(e)
	#var target_type_and_name := self.get_obj_type_and_name(e.target)
	#var caster_type_and_name := self.get_obj_type_and_name(e.caster)
	#self.put_text(EFFECT_APPLYED_PLACEHOLDER % [
		#Utils.colorful(effect_type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(effect_type_and_name[1], OBJ_NAME_COLOR),	
		#Utils.colorful(target_type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(target_type_and_name[1], OBJ_NAME_COLOR),
		#Utils.colorful(caster_type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(caster_type_and_name[1], OBJ_NAME_COLOR),
	#])
#
#func effect_activated_log(e: Effect) -> void:
	#var effect_type_and_name := self.get_obj_type_and_name(e)
	#var target_type_and_name := self.get_obj_type_and_name(e.target)
	#self.put_text(EFFECT_ACTIVATED_PLACEHOLDER % [
		#Utils.colorful(effect_type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(effect_type_and_name[1], OBJ_NAME_COLOR),	
		#Utils.colorful(target_type_and_name[0], OBJ_TYPE_COLOR),
		#Utils.colorful(target_type_and_name[1], OBJ_NAME_COLOR),
	#])
#
#
#func score_points_updated_log(old: int, new: int, diff: int) -> void:
	#var diff_color := SCORE_NEGATIVE_DIFF_COLOR if diff < 0 else SCORE_DIFF_COLOR
	#self.put_text(SCORE_POINTS_CHANGE_PLACEHOLDER % [
		#Utils.colorful(str(old), SCORE_OLD_VAL_COLOR),
		#Utils.colorful(str(new), SCORE_NEW_VAL_COLOR),
		#Utils.colorful(str(diff), diff_color),
	#])
#
#func score_multiplier_updated_log(old: int, new: int, diff: int) -> void:
	#var diff_color := SCORE_NEGATIVE_DIFF_COLOR if diff < 0 else SCORE_DIFF_COLOR
	#self.put_text(SCORE_FACTOR_CHANGE_PLACEHOLDER % [
		#Utils.colorful(str(old), SCORE_OLD_VAL_COLOR),
		#Utils.colorful(str(new), SCORE_NEW_VAL_COLOR),
		#Utils.colorful(str(diff), diff_color),
	#])
#
#func score_total_score_updated_log(old: int, new: int, diff: int) -> void:
	#var diff_color := SCORE_NEGATIVE_DIFF_COLOR if diff < 0 else SCORE_DIFF_COLOR
	#self.put_text(SCORE_TOTAL_SCORE_CHANGE_PLACEHOLDER % [
		#Utils.colorful(str(old), SCORE_OLD_VAL_COLOR),
		#Utils.colorful(str(new), SCORE_NEW_VAL_COLOR),
		#Utils.colorful(str(diff), diff_color),
	#])
#
#
#func get_obj_type_and_name(obj: Variant) -> Array[String]:
	#var obj_type: String = obj.get_script().get_global_name()
	#var obj_name: String
	#match obj_type:
		#'Card':
			#obj_name = (obj as Card).card_name
		#'Combo':
			#obj_name = (obj as Combo).combo_name
		## NOTE: this case for cursors
		#'Cursor':
			#obj_name = 'CardCursor' if obj.type == Cursor.TYPE.CARDS else 'ComboCursor'
		#_:
			#obj_name = obj.name
#
	#var type_and_name: Array[String] = [obj_type, obj_name]
	#return type_and_name
#
#
#func connect_battle_signals() -> void:
	#Events.connect_events({
		#obj_created = self.obj_created_log,
		#obj_prop_changed = self.obj_prop_changed_log,
		#obj_destroyed = self.obj_has_destroyed_log,
#
		#battle_started = self.battle_started_log,
		#battle_ended = self.battle_ended_log,
#
		#round_preparation_started = self.round_preparation_started_log,
		#round_started = self.round_started_log,
		#round_ended = self.round_ended_log,
		#round_exit = self.round_exit_log,
#
		#card_started = self.card_started_log ,
		#card_ended = self.card_ended_log ,
		#card_exit = self.card_exit_log ,
#
		#combo_started = self.combo_started_log ,
		#combo_ended = self.combo_ended_log ,
		#combo_exit = self.combo_exit_log ,
#
		#effect_applyed = self.effect_applyed_log ,
		#effect_activated = self.effect_activated_log ,
#
		#score_points_updated = self.score_points_updated_log ,
		#score_multiplier_updated = self.score_multiplier_updated_log ,
		#score_total_score_updated = self.score_total_score_updated_log ,
	#})
