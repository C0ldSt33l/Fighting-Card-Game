class_name Combo

var name: String
var description: String

var price: int
var points: int
var multiplayer: int

var pattern: Dictionary
var length: int :
    get():
        return self.pattern.size() 

var effect: Callable


signal played(points: int, multiplayer: int, effect: Callable)


func _init(
    name: String,
    config: Dictionary
) -> void:
    self.name = name
    for prop in config:
        self[prop] = config[prop]


func check(cards: Array[Card]) -> bool:
    var i := 0
    for prop in self.pattern:
        if cards[i] == null: return false
        if cards[i][prop] != self.pattern[prop]:
            return false
        i += 1
    return true
    

# NOTE: which signature is more suitable:
    # - (score: int, multiply: int) -> void
    # - (score: Vector2i) -> void
    # - (cards: Array[Card], cur_pos: int) -> void
    # - (score: Vector2i, cards: Array[Card], cur_pos: int) -> void
func apply_effect() -> void:
    self.effect.call()