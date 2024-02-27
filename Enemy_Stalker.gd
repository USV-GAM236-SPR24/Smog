extends CharacterBody2D

var speed = 15
var player_chase = false
" ^^ his is under the assumption that the stalker will have a 'stalk' phase and thus not always be
the snail of death"

var player = null

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed 


func _on_detection_area_area_entered(body):
	player = body
	player_chase = true
	pass # Replace with function body.
"If player in zone, chase. If not, don't chase."
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

