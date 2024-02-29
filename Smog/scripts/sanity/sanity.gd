extends Node

signal sanity_empty
signal sanity_full
signal sanity_changed(old: float, new: float)

const MAXIMUM: float = 100
const MINIMUM: float = 0

var current: float: # accesses _current
	get:
		return _current
	set(value):
		push_warning(_manual_set_message("change")) # warning because variable was not meant to be set manually
		change(value)
var is_empty: bool: # accesses _is_empty
	get:
		return _is_empty
	set(value):
		push_error(_manual_set_message("empty")) # error because variable cannot be set manually
var is_full: bool: # accesses _is_full
	get:
		return _is_full
	set(value):
		push_error(_manual_set_message("fill")) # error because variable cannot be set manually

var _current: float = MAXIMUM
var _is_empty: bool = false
var _is_full: bool = true

func _ready():
	sanity_changed.connect(save_sanity_value)
	
	if SaveSystem.has("sanity_value") == false:
		SaveSystem.set_var("sanity_value", _current)
		SaveSystem.save()
	else:
		pass
		#TODO set current sanity value to save system variable

func save_sanity_value(old: float, new: float):
	print("saved sanity value: ", old, " ", new)
	SaveSystem.set_var("sanity_value", new)
	SaveSystem.save()


func fill() -> float:
	var old: float = _current # to emit changed signal
	_current = MAXIMUM
	_is_empty = false
	_is_full = true
	sanity_full.emit()
	if old != _current:
		sanity_changed.emit(old, _current)
	return _current


func empty() -> float:
	var old: float = _current # to emit changed signal
	_current = MINIMUM
	_is_full = false
	_is_empty = true
	sanity_empty.emit()
	if old != _current:
		sanity_changed.emit(old, _current)
	return _current


func change(new: float) -> float:
	var delta: float = new - _current
	if delta < 0:
		return decrease(abs(delta))
	elif delta > 0:
		return increase(delta)
	return _current


func decrease(decrement: float) -> float:
	if decrement == 0 or _current == MINIMUM: # nothing will change
		return _current
	elif decrement < 0: # use increase instead!
		push_error("Cannot decrease sanity by a negative value. Using increase function instead.")
		increase(abs(decrement))
		return _current
	
	var old: float = _current # to emit changed signal
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


func increase(increment: float) -> float:
	if increment == 0 or _current == MAXIMUM: # nothing will change
		return _current
	elif increment < 0: # use decrease instead!
		push_error("Cannot increase sanity by a negative value. Using decrease function instead.")
		decrease(abs(increment))
		return _current
	
	var old: float = _current # to emit changed signal
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


func _manual_set_message(func_name: String) -> String:
	return "This variable was not intended to be modified manually. Please use Sanity." + func_name + "() instead."
