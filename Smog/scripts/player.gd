class_name Player
extends Entity

signal position_changed(old: Vector2, new: Vector2)

var input_direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.RIGHT
var shoot_range = 500
var can_poke: bool = true

@export var player_acceleraction : float = 10

@onready var all_interactions = []
@onready var interactLabel = $"Interaction Components/InertactLabel"


func _enter_tree() -> void:
	$"Interaction Components/InteractionArea".area_entered.connect(_on_interaction_area_area_entered)
	$"Interaction Components/InteractionArea".area_exited.connect(_on_interaction_area_area_exited)
	Sanity.sanity_empty.connect(die)
	speed = 100


func _ready():
	position_changed.connect(save_position_value)
	if SaveSystem.has("position_value") == false:
		var current_pos = position
		SaveSystem.set_var("position_value", current_pos)
		SaveSystem.save()
		print("set position value to current", current_pos)
	else:
		var saved_value
		saved_value = SaveSystem.get_var("position_value")
		print("Loaded position value: ", SaveSystem.get_var("position_value"))
	$AnimatedSprite2D.play("idle_right")
	update_interactions()

func save_position_value(old:Vector2 , new:Vector2 ):
	print("saved position value: ", old, " ", new)
	SaveSystem.set_var("position_value", new)
	SaveSystem.save()

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
		
	if Input.is_action_just_pressed("melee") and can_poke and not %Gun.shoot_mode:
		%Cane.poke()
		can_poke = false
		
		#can only poke once every ___ seconds
		await get_tree().create_timer(0.6).timeout
		can_poke = true


func _physics_process(_delta):
	#get input direction
	input_direction = _round_to_nearest_direction(Input.get_vector("left", "right", "up", "down"))
	
	#udatpe animation
	update_animation(input_direction)
	
	#update gun aim
	%Gun.update_gun_aim(input_direction)
	
	#update poke collisions
	%Cane._update_collision()
	
	#update velocity
	velocity = input_direction * speed
	#Move and Slide
	move_and_slide()


#Animation
func update_animation(move_input : Vector2):
	$AnimatedSprite2D.flip_h = false
	if move_input == Vector2.ZERO:
		match last_direction:
			Vector2.RIGHT:
				$AnimatedSprite2D.play("idle_right")
			Vector2.LEFT:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("idle_right")
			Vector2.UP:
				$AnimatedSprite2D.play("idle_up")
			Vector2.DOWN:
				$AnimatedSprite2D.play("idle_down")
		return
	if abs(move_input.x) >= abs(move_input.y): # moving left-right faster than up-down
		$AnimatedSprite2D.play("walking_right")
		if move_input.x > 0:
			last_direction = Vector2.RIGHT
		else:
			$AnimatedSprite2D.flip_h = true
			last_direction = Vector2.LEFT
	else: # moving up-down faster than left-right
		if move_input.y > 0:
			$AnimatedSprite2D.play("walking_down")
			last_direction = Vector2.DOWN
		else:
			$AnimatedSprite2D.play("walking_up")
			last_direction = Vector2.UP


func update_interactions():
	if all_interactions:
		interactLabel.text = all_interactions[0].interact_label
	else:
		interactLabel.text = ""


func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		cur_interaction.interact()


#Interaction Methods
func _on_interaction_area_area_entered(area):
	if not area is Interactable:
		return
	all_interactions.insert(0, area)
	update_interactions()


func _on_interaction_area_area_exited(area):
	if not area is Interactable:
		return
	all_interactions.erase(area)
	update_interactions()
	
func _round_to_nearest_direction(input_vector: Vector2) -> Vector2:
	var rounded_vector = input_vector.normalized() 
	if abs(rounded_vector.x) >= abs(rounded_vector.y):
		rounded_vector.y = 0
		rounded_vector.x = round(rounded_vector.x) 
	else:
		rounded_vector.x = 0
		rounded_vector.y = round(rounded_vector.y) 
	
	return rounded_vector
	
func _hide(vis: bool):
	$AnimatedSprite2D.visible = not vis
	print("Toggling hide: ", $AnimatedSprite2D.visible)
