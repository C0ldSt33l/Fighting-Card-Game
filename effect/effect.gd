class_name effect

var effect_name: String
var description: String
var effect: Callable

enum ACTIVATION_TIME {
    BEFORE_ROUND,
    WHILE_ROUND,
    AFTER_ROUND,
}
var activation_time: ACTIVATION_TIME


func _init(
    name: String,
    desc: String,
    activation_time: ACTIVATION_TIME,
    effect: Callable
) -> void:
    self.effect_name = name
    self.description = desc
    self.activation_time = activation_time
    self.effect = effect