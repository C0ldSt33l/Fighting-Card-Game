extends Node2D

@onready var logger := $Logger as RichTextLabel 

func _ready() -> void:
	var card_factory := preload("res://card/card.tscn")
	var configs := [
		{
			'action_name': 'fist',
			'type': Card.ACTION_TYPE.ARM_STRIKE,
			'dmg': 2
		},
		{
			'action_name': 'kick',
			'type': Card.ACTION_TYPE.LEG_STRIKE,
			'dmg': 3
		},
		{
			'action_name': 'elbow',
			'type': Card.ACTION_TYPE.ARM_STRIKE,
			'dmg': 5
		},
	]

	var pos = 200
	for config in configs:
		var node := card_factory.instantiate() as Card
		node.position.x = pos
		node.created.connect(self.add_text)
		for key in config:
			node[key] = config[key]
		self.add_child(node)
		pos += 150



func _process(delta: float) -> void:
	pass


func add_text(text: String) -> void:
	text += "\n"
	self.logger.text += text
