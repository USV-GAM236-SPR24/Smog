class_name Player
extends Entity


var last_direction: Vector2 = Vector2.RIGHT
var shoot_range = 500
var aim_dir

var has_axe: bool = true
var swinging_axe: bool = false
var input_direction: Vector2

@export var player_acceleraction : float = 10

@onready var all_interactions = []
@onready var interactLabel = $"Interaction Components/InertactLabel"


func _enter_tree() -> void:
	$"Interaction Components/InteractionArea".area_entered.connect(_on_interaction_area_area_entered)
	$"Interaction Components/InteractionArea".area_exited.connect(_on_interaction_area_area_exited)
	Sanity.sanity_empty.connect(die)
	speed = 65


func _ready():
	$AnimatedSprite2D.play("idle_right")
	update_interactions()


func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	if Input.is_action_just_pressed("swing"):
		_swing()


func _physics_process(_delta):
	#get input direction.... NO DIAGONAL MOVEMENT
	input_direction = _round_to_direction(Input.get_vector("left", "right", "up", "down"))
	
	#udatpe animation
	update_animation(input_direction)
	
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
		match cur_interaction.interact_type:
			"print_text" : print(cur_interaction.interact_value)
			"pickup":
				var pickup: Consumable = ConsumableFactory.create(cur_interaction.interact_value)
				get_node("/root/Game/Inventory").add_item(pickup)


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

func _round_to_direction(input_vector: Vector2) -> Vector2:
	var direction = input_vector.normalized()
	var dominant_axis = "x" if abs(direction.x) >= abs(direction.y) else "y"
	
	var rounded_vector = Vector2.ZERO
	rounded_vector[dominant_axis] = sign(direction[dominant_axis])
	
	return rounded_vector
	
func _swing() -> void:
	if %Gun.shoot_mode or swinging_axe:
		return
	
	swinging_axe = true
	
	$AxeSwingSprite.visible = true
	$AnimatedSprite2D.visible = false
	
	await get_tree().create_timer(0.2).timeout
	
	if has_axe:
		_do_swing_anim(input_direction)
	
	await get_tree().create_timer(0.5).timeout
	
	$AnimatedSprite2D.visible = true
	$AxeSwingSprite.visible = false
	
	swinging_axe = false
	
#no one look at this
func _do_swing_anim(input_direction: Vector2):
		match input_direction:
			Vector2.RIGHT:
				%AnimationPlayer.play("swing_right")
				var bodies: Array = $SwingCollisions/right_swing_collision.get_overlapping_bodies()
				for body in bodies:
					if body is Enemy:
						print('hitting')
						body._on_hit()
			Vector2.LEFT:
				%AnimationPlayer.play("swing_left")
				var bodies: Array = $SwingCollisions/left_swing_collision.get_overlapping_bodies()
				for body in bodies:
					if body is Enemy:
						print('hitting')
						body._on_hit()
			Vector2.UP:
				%AnimationPlayer.play("swing_up")
				var bodies: Array = $SwingCollisions/up_swing_collision.get_overlapping_bodies()
				for body in bodies:
					if body is Enemy:
						print('hitting')
						body._on_hit()
			Vector2.DOWN:
				%AnimationPlayer.play("swing_down")
				var bodies: Array = $SwingCollisions/down_swing_collision.get_overlapping_bodies()
				for body in bodies:
					if body is Enemy:
						print('hitting')
						body._on_hit()
			Vector2.ZERO:
				match last_direction:
							Vector2.RIGHT:
								%AnimationPlayer.play("swing_right")
								var bodies: Array = $SwingCollisions/right_swing_collision.get_overlapping_bodies()
								for body in bodies:
									if body is Enemy:
										print('hitting')
										body._on_hit()
							Vector2.LEFT:
								%AnimationPlayer.play("swing_left")
								var bodies: Array = $SwingCollisions/left_swing_collision.get_overlapping_bodies()
								for body in bodies:
									if body is Enemy:
										print('hitting')
										body._on_hit()
							Vector2.UP:
								%AnimationPlayer.play("swing_up")
								var bodies: Array = $SwingCollisions/up_swing_collision.get_overlapping_bodies()
								for body in bodies:
									if body is Enemy:
										print('hitting')
										body._on_hit()
							Vector2.DOWN:
								%AnimationPlayer.play("swing_down")
								var bodies: Array = $SwingCollisions/down_swing_collision.get_overlapping_bodies()
								for body in bodies:
									if body is Enemy:
										print('hitting')
										body._on_hit()
