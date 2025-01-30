class_name Combo

var pattern: Dictionary
var length: int :
	get():
		return self.pattern.size() 
var effect: Callable


func check(cards: Array[Card]) -> bool:
	var i := 0
	for prop in self.pattern:
		if cards[i][prop] != self.pattern[prop]:
			return false
		i += 1
	return true
	

# NOTE: which signature is more suitable:
	# - (score: int, multiply: int) -> void
	# - (score: Vector2i) -> void
	# - (cards: Array[Card]) -> void
	# - (score: Vector2i, cards: Array[Card]) -> void
func apply_effect() -> void:
	self.effect.call()
