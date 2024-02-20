extends Object
class_name Sanity


signal sanity_drained

var maximum: int = 100
var current: int = 100
var drained: bool = false


func reset() -> void:
	current = maximum
	drained = false


func decrease(decrement: int) -> void:
	current -= decrement
	if current <= 0:
		sanity_drained.emit()
		drained = true

func increase(increment: int) -> void:
	current += increment
	if drained and current > 0:
		drained = false
