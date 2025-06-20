extends Button

signal buy_skill(port)

func _on_pressed() -> void:
	buy_skill.emit(self)
	pass # Replace with function body.
