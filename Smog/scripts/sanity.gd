extends Node


signal sanity_empty
signal sanity_full
signal sanity_changed(old: int, new: int)

const MAXIMUM: int = 100
const MINIMUM: int = 0

var current: int:
	get:
		return _current
	set(value):
		change(value - _current)
var is_empty: bool:
	get:
		return _is_empty
	set(value):
		empty()
var is_full: bool:
	get:
		return _is_full
	set(value):
		fill()

var _current: int = 100
var _is_empty: bool = false
var _is_full: bool = true


func fill() -> int:
	var old: int = _current # to emit changed signal
	_current = MAXIMUM
	_is_empty = false
	_is_full = true
	sanity_full.emit()
	if old != _current:
		sanity_changed.emit(old, _current)
	return _current


func empty() -> int:
	var old: int = _current # to emit changed signal
	_current = MINIMUM
	_is_full = false
	_is_empty = true
	sanity_empty.emit()
	if old != _current:
		sanity_changed.emit(old, _current)
	return _current


func change(delta: int) -> int:
	if delta < 0:
		return decrease(abs(delta))
	elif delta > 0:
		return increase(delta)
	return _current


func decrease(decrement: int) -> int:
	if decrement == 0 or _current == MINIMUM: # nothing will change
		return _current
	elif decrement < 0: # use increase instead!
		push_error("Cannot decrease sanity by a negative value. Using increase function instead.")
		increase(abs(decrement))
		return _current
	
	var old: int = _current # to emit changed signal
	_current -= decrement
	
	if _current <= MINIMUM:
		_current = MINIMUM # cannot go under minimum
		if not _is_empty: # prevents emitting repetitively
			_is_empty = true
			sanity_empty.emit()
	
	if _is_full:
		_is_full = false
	
	if old != _current: # just in case
		sanity_changed.emit(old, _current)
	
	return _current


func increase(increment: int) -> int:
	if increment == 0 or _current == MAXIMUM: # nothing will change
		return _current
	elif increment < 0: # use decrease instead!
		push_error("Cannot increase sanity by a negative value. Using decrease function instead.")
		decrease(abs(increment))
		return _current
	
	var old: int = _current # to emit changed signal
	_current += increment
	
	if _current >= MAXIMUM:
		_current = MAXIMUM # cannot go over maximum
		if not _is_full: # prevents emitting repetitively
			_is_full = true
			sanity_full.emit()
	
	if _is_empty:
		_is_empty = false
	
	if old != _current: # just in case
		sanity_changed.emit(old, _current)
	
	return _current
