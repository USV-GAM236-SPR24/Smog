extends CharacterBody2D

var speed = 10

var player_chase = true
" ^^ his is under the assumption that the stalker will have a 'stalk' phase and thus not always be
the snail of death"


@onready var player = $/root/Node2D/player


func _physics_process(delta):
	
	velocity = speed*position.direction_to(player.position)
	
	if position.distance_to(player.position) < 20:
		
		player_chase = true
	if player_chase:
		#position += (player.position - position)/speed 
		move_and_slide()


func _on_detection_area_body_entered(body):
	print("Detected!")
	if body.name == "player":
		player = body
		player_chase = true
	pass # Replace with function body.
"If player in zone, chase. If not, don't chase."
func _on_detection_area_body_exited(body):
	if body.name == "player":
		player = null
		player_chase = false


