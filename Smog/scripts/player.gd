class_name Player
extends CharacterBody2D


@export var player_move_speed : float = 10
@export var player_acceleraction : float = 10
@export var starting_direction : Vector2 = Vector2(0, 0.5)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var all_interactions = []
@onready var interactLabel = $"Interaction Components/InertactLabel"


func _ready():
	update_animation_parameters(starting_direction)
	update_interactions()


func _process(_delta):
	#interact
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	
	if Input.is_action_just_pressed("shoot") and $RayCast2D.is_colliding():
		print("Player recognized Enemy")
		var collider = $RayCast2D.get_collider()
		if collider.has_method("_on_shoot"):
			print("ye")
			collider._on_shoot()


func _physics_process(_delta):

	#get input direction
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	#udatpe animation
	update_animation_parameters(input_direction)
	
	#update velocity
	velocity = input_direction * player_move_speed
	#Move and Slide
	move_and_slide()
	
	pick_new_state()


#Animation
func update_animation_parameters(move_input : Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)


func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")


#Interaction Methods
func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()


func update_interactions():
	if all_interactions:
		interactLabel.text = all_interactions[0].interact_label
	else:
		interactLabel.text = ""


func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"print_text" : print(cur_interaction.interact_value)
