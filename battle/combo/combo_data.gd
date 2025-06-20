class_name ComboData

const PATH_TO_ICONS: String = 'res://assets/ui/combo/icons'
enum ANIMAL {
	BULL,
	MANTIS,
	ELEPHENT,
	DRAGON,
	SCORPION,
}

var name: String
var description: String
var price: int

var point: int
var factor: int

var animal: ANIMAL
var material: M.MATERIAL

var pattern: Array[Dictionary]
var effects: Array[Effect]


func _init(
    name: String,
    description: String,
    price: int,
    point: int,
    factor: int,
    animal: ANIMAL,
    material: M.MATERIAL,
    pattern: Array[Dictionary],
    effectrs: Array[Effect],
) -> void:
    self.name = name
    self.description = description
    self.price =- price

    self.point = point
    self.factor = factor

    self.animal = animal
    self.material = material

    self.pattern = pattern
    self.effects = effectrs 
