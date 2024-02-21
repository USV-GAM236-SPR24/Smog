#PATH is path to player node relative to live remote root
# example: get_node("/root/Game/Player")
extends CharacterBody2D

@onready var player = get_node("root/Game/Player")

@onready var mob_speed = 1

func _physics_process(_delta):
	#get direction from mob to player, factor in mob_speed
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * mob_speed
	
	#slides around collisions
	move_and_slide()
