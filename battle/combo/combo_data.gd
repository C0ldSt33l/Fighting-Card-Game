class_name ComboData

var name: String
var description: String
var price: int

var point: int
var factor: int

var animal: Combo.ANIMAL
var material: M.MATERIAL


func _init(
    name: String,
    description: String,
    price: int,
    point: int,
    factor: int,
    animal: Combo.ANIMAL,
    material: M.MATERIAL,
) -> void:
    self.name = name
    self.description = description
    self.price =- price

    self.point = point
    self.factor = factor

    self.animal = animal
    self.material = material
