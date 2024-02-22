extends CharacterBody2D

@export var player_move_speed : float = 10

func _physics_process(delta):
	
	#get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("up") - Input.get_action_strength("down")
	)
	
	#print(input_direction)
	
	#update velocity
	velocity = input_direction * player_move_speed
	
	#Move and Slider
	move_and_slide()
