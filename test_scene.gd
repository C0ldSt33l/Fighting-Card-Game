extends Node2D

@onready var logger := $Logger as RichTextLabel 
@onready var timer := $Timer as Timer

var cards: Array[Card] = []
var cur_card := 0

func _ready() -> void:
	var configs := [
		{
			'card_name': 'fist',
			'type': Card.ACTION_TYPE.ARM_STRIKE,
			'dmg': 2
		},
		{
			'card_name': 'kick',
			'type': Card.ACTION_TYPE.LEG_STRIKE,
			'dmg': 3
		},
		{
			'card_name': 'elbow',
			'type': Card.ACTION_TYPE.ARM_STRIKE,
			'dmg': 5
		},
	]
	var spawn_pos := Vector2(300, 100)

	for config in configs:
		self.spawn_card(config, spawn_pos)
		spawn_pos.x += 150


func add_text(text: String) -> void:
	text += "\n"
	self.logger.text += text


func create_log(name: String) -> void:
	self.add_text(name + ' has created')


func action_log(name: String, dmg: int) -> void:
	self.add_text(name + ' has dealed dmg: ' + str(dmg))


func destroy_log(name: String) -> void:
	self.add_text(name + ' has destroyed')


func start_round() -> void:
	self.timer.start()


func end_round() -> void:
	self.timer.stop()

	self.cur_card = 0
	for card in self.cards:
		card.queue_free()
	self.cards.clear()


func play_card() -> void:
	self.cards[self.cur_card].play()
	self.cur_card += 1
	if self.cur_card == self.cards.size():
		self.end_round()


func spawn_card(config: Dictionary, pos: Vector2) -> void:
	var card := CardFactory.create_with_binding(
		self,
		func (c: Card) -> void:
			c.add_tags(config)
			c.position = pos
			c.created.connect(self.create_log)
			c.played.connect(self.action_log)
			c.destroyed.connect(self.destroy_log)
	)

	self.cards.append(card)
