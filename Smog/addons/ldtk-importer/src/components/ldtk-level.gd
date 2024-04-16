@icon("ldtk-level.svg")
@tool
class_name LDTKLevel
extends Node2D


var factory_world: PackedScene = load("res://worlds/factory_world.tscn")

@export var size: Vector2i
@export var fields: Dictionary
@export var neighbours: Array
@export var bg_color: Color


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(Vector2.ZERO, size), bg_color, false, 2.0)


func change_to_factory(player: Player) -> void:
	get_parent().call_deferred("add_child", factory_world.instantiate())
	player.free()
	queue_free()
