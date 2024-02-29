extends CharacterBody2D



var speed = 25 #arbitrary number since was made before player was merged
var player_chase = false
var player = null

func _ready():
	#var _sanity_reference = get_node("res://scripts/sanity.gd")
	pass

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		
	else:
		$AnimatedSprite2D.play("idle")



func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	

func _on_hitbox_body_entered(body):
	if body.is_in_group(player):
		Sanity.decrease(1)
