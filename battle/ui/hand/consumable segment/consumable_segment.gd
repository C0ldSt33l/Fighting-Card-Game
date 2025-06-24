extends Control
class_name ComsumableSegment

@onready var consumable_container: GridContainer = $"Consumable placeholder/MarginContainer/Consumable container"

var CONSUMABLE_TEMPLATE: Consumable = preload("res://battle/consumable/consumable.tscn").instantiate()

var configs: Array[Dictionary] = [
	{
		name = 'Финт',
		description = 'Карта срабатывает дважды',
		image = preload("res://assets/ui/consumable/fast.png"),
		effect = Effects.get_effect('Again')
	},
	{
		name = 'Сила',
		description = 'Увеличивает очки карты на 1',
		image = preload("res://assets/ui/consumable/power_up.png"),
		effect = Effects.get_effect('Card power')
	},
	{
		name = 'Сила+',
		description = 'Увеличивает очки карты на 2',
		image = preload("res://assets/ui/consumable/power_up.png"),
		effect = Effects.get_effect('Card power+')
	},
]


func _ready() -> void:
	for i in 3:
		var c: Consumable = CONSUMABLE_TEMPLATE.duplicate()
		self.add_consumable(c)
		var d := configs[i]
		c.comsumable_name = d.name
		c.description = d.description
		c.image = d.image
		c.effect = d.effect
		
func add_consumable(c: Consumable) -> void:
	self.consumable_container.add_child(c)
