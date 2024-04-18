extends Area2D


@onready var office_world = get_parent().get_parent()
@onready var factory_world = load("res://worlds/factory_world2.tscn").instantiate()


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D):
	if body is Player:
		office_world.get_parent().add_child(factory_world)
		office_world.queue_free()
