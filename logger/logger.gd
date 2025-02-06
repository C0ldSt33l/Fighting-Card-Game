class_name Logger
extends RichTextLabel 

var OBJ_PLACEHOLDER := 'Obj %s type of %s' % [colorful('%s', Color.WHITE), colorful('%s', Color.WHITE)]

'''
Possible colorful log elements:
- log type
- obj name
- obj type
- Score:
	- old val
	- new val
	- diff
'''


func _ready() -> void:
	self.bbcode_enabled = true
	self.add_theme_color_override('default_color', Color.GRAY)


func put_text(text: String) -> void:
	self.append_text(text + '\n')


func obj_has_created_log(obj: Variant) -> void:
	var name_and_type := self.get_obj_name_and_type(obj)
	self.put_text((OBJ_PLACEHOLDER + ' has created') % name_and_type) 


func change_points_log(old: int, new: int, diff: int) -> void:
	var diff_color := Color.RED if diff < 0 else Color.GREEN
	var placeholder := 'Score change: points %s -> %s: %s' % [colorful('%d', Color.WHITE), colorful('%d', Color.WHITE), colorful('%d', diff_color)]
	self.put_text(placeholder % [old, new, diff])


func change_multiplier_log(old: int, new: int, diff: int) -> void:
	var diff_color := Color.RED if diff < 0 else Color.GREEN
	var placeholder := 'Score change: multiplier %s -> %s: %s' % [colorful('%d', Color.WHITE), colorful('%d', Color.WHITE), colorful('%d', diff_color)]
	self.put_text(placeholder % [old, new, diff])


func change_total_score_log(old: int, new: int, diff: int) -> void:
	var diff_color := Color.RED if diff < 0 else Color.GREEN
	var placeholder := 'Score change: total score %s -> %s: %s' % [colorful('%d', Color.WHITE), colorful('%d', Color.WHITE), colorful('%d', diff_color)]
	self.put_text(placeholder % [old, new, diff])


func card_has_played_log(card: Card) -> void:
	var placeholder := 'Card ' + colorful('%s', Color.WHITE) + ' has dealed dmg: ' + colorful('%d', Color.RED)
	self.put_text(placeholder % [card.card_name, card.dmg])


func combo_has_activated(combo: Combo) -> void:
	var placeholder := 'Combo' + colorful(' %s ', Color.WHITE) + 'has activated'
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
