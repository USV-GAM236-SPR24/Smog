class_name Interactable
extends Node

enum InteractType {
	NONE,
	RESTORE,
	PICKUP,
	DISCOVERABLE
}

var interact_label: String
var interact_type := InteractType.NONE
var interact_value: String
var is_single_use := false
var interacted := false


#func _init(new_label, new_type, new_value, single_use) -> void:
	#interact_label = new_label
	#interact_type = new_type
	#interact_value = new_value
	#is_single_use = single_use


func interact() -> void:
	if is_single_use and interacted:
		return
	_interact()
	interacted = true
	_post_interact()
	if is_single_use:
		_free()


func _interact() -> void:
	pass


func _post_interact() -> void:
	pass


func _free() -> void:
	queue_free()
