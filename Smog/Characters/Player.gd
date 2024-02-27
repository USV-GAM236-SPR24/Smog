extends CharacterBody2D

@export var player_move_speed : float = 10

func _physics_process(delta):
	
	#get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	#print(input_direction)
	
	#update velocity
	velocity = input_direction * player_move_speed
	
	#Move and Slide
	move_and_slide()
