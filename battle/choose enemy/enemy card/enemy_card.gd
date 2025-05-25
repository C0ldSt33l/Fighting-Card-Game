extends Control
class_name EnemyCard

@onready var background: Panel = $Background
@onready var stylebox: StyleBoxFlat :
	set(val):
		self.background.add_theme_stylebox_override('panel', val)
	get():
		return background.get_theme_stylebox('panel')
@onready var bg_color: Color :
	set(val):
		self.stylebox.bg_color = val
	get():
		return self.stylebox.bg_color
@onready var border_width: int :
	set(val):
		self.stylebox.set_border_width_all(val)
	get():
		return self.stylebox.get_border_width_min()
@onready var border_color: Color :
	set(val):
		self.stylebox.border_color = val
	get():
		return self.stylebox.border_color

@onready var enemy_name: String = 'Enemy' :
	set(val):
		var capitalized := val.capitalize()
		enemy_name = capitalized
		self.name_lbl.text = capitalized 
@onready var name_lbl: Label = $"Background/Margins/Content container/Name" as Label
@onready var image: Texture2D : 
	set(val): self.image_rect.texture = val
	get(): return self.image_rect.texture
@onready var image_rect: TextureRect = $"Background/Margins/Content container/Image"
@onready var required_score: int :
	set(val):
		required_score = val
		self.required_score_lbl.text = 'Score: %s' % [val]
@onready var required_score_lbl: Label = $"Background/Margins/Content container/Required score"

var is_mouse_inside: bool = false


signal choosed(c: EnemyCard)


func _ready() -> void:
	self.stylebox = self.stylebox.duplicate()
	pass


## Call this func after adding this node to another
func setup(
	name: String,
	image_path: String,
	required_score: int
) -> void:
	self.enemy_name = name
	# self.image = load(image_path)
	self.required_score = required_score
	

func get_enemy_data() -> Dictionary:
	return {
		enemy_name = self.enemy_name,
		image = self.image,
		required_score = self.required_score,
	}


func _on_background_mouse_entered() -> void:
	self.is_mouse_inside = true
	self.border_width = 5


func _on_background_mouse_exited() -> void:
	self.is_mouse_inside = false
	self.border_width = 0


func _on_background_gui_input(event: InputEvent) -> void:
	if self.is_mouse_inside and event.is_action_pressed('click'):
		self.choosed.emit(self)

func _to_string() -> String:
	return '<%s#%s>{ name: %s, image: %s, score: %s }' % [
		'Enemy card',
		self.get_instance_id(),
		self.enemy_name,
		self.image,
		self.required_score
	]
