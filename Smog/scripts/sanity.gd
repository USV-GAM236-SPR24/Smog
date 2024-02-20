extends Node


signal sanity_empty
signal sanity_full
signal sanity_changed(old: int, new: int)

var maximum: int = 100
var current: int = 100
var is_empty: bool = false
var is_full: bool = true


func fill() -> void:
	var old: int = current # to emit changed signal
	current = maximum
	is_empty = false
	is_full = true
	sanity_full.emit()
	if old != current:
		sanity_changed.emit(old, current)


func empty() -> void:
	var old: int = current # to emit changed signal
	current = 0
	is_full = false
	is_empty = true
	sanity_empty.emit()
	if old != current:
		sanity_changed.emit(old, current)


func change(delta: int) -> void:
	if delta < 0:
		decrease(abs(delta))
	elif delta > 0:
		increase(delta)


func decrease(decrement: int) -> void:
	if decrement == 0 or current == 0: # nothing will change
		return
	elif decrement < 0: # use increase instead!
		push_error("Cannot decrease sanity by a negative value. Using increase function instead.")
		increase(abs(decrement))
		return
	
	var old: int = current # to emit changed signal
	current -= decrement
	
	if current <= 0:
		current = 0 # cannot go under minimum
		if not is_empty: # prevents emitting repetitively
			is_empty = true
			sanity_empty.emit()
	
	if is_full:
		is_full = false
	
	if old != current: # just in case
		sanity_changed.emit(old, current)


func increase(increment: int) -> void:
	if increment == 0 or current == 0: # nothing will change
		return
	elif increment < 0: # use decrease instead!
		push_error("Cannot increase sanity by a negative value. Using decrease function instead.")
		decrease(abs(increment))
		return
	
	var old: int = current # to emit changed signal
	current += increment
	
	if current >= maximum:
		current = maximum # cannot go over maximum
		if not is_full: # prevents emitting repetitively
			is_full = true
			sanity_full.emit()
	
	if is_empty:
		is_empty = false
	
	if old != current: # just in case
		sanity_changed.emit(old, current)
