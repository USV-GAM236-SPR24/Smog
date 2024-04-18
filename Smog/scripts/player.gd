class_name Player
extends Entity

signal position_changed(old: Vector2, new: Vector2)

static var current_player: Player

var input_direction: Vector2 = Vector2.ZERO
var input_array: Array[Vector2] = [Vector2.ZERO]
var last_direction: Vector2 = Vector2.RIGHT
var shoot_range = 500
var attacking: bool = false
var weapon: Weapon

@export var player_acceleraction : float = 10

@onready var all_interactions = []
@onready var interactLabel = $"Interaction Components/InertactLabel"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var death_sfx = $Death


func _enter_tree() -> void:
	Player.current_player = self
	$"Interaction Components/InteractionArea".area_entered.connect(_on_interaction_area_area_entered)
	$"Interaction Components/InteractionArea".area_exited.connect(_on_interaction_area_area_exited)
	Sanity.sanity_empty.connect(die)
	speed = 60


func _ready():
	weapon = %Cane
	#sprite.animation_finished.connect(Callable(func(): sprite.offset = Vector2.ZERO))
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
	update_interactions()


func save_position_value(old:Vector2 , new:Vector2 ):
	print("saved position value: ", old, " ", new)
	SaveSystem.set_var("position_value", new)
	SaveSystem.save()


func _process(_delta):
	#var input_magnitude: float = Input.get_vector("left", "right", "up", "down").length()
	#input_direction = _round_to_nearest_direction(Input.get_vector("left", "right", "up", "down"))
	input_array.clear()
	input_direction = Vector2.ZERO
	if Input.is_action_pressed("left"):
		input_array.append(Vector2.LEFT)
	if Input.is_action_pressed("right"):
		input_array.append(Vector2.RIGHT)
	if Input.is_action_pressed("up"):
		input_array.append(Vector2.UP)
	if Input.is_action_pressed("down"):
		input_array.append(Vector2.DOWN)
	
	if Input.is_action_just_pressed("left"):
		last_direction = Vector2.LEFT
	if Input.is_action_just_pressed("right"):
		last_direction = Vector2.RIGHT
	if Input.is_action_just_pressed("up"):
		last_direction = Vector2.UP
	if Input.is_action_just_pressed("down"):
		last_direction = Vector2.DOWN

	if input_array.size() > 0:
		input_direction = input_array[-1]
	
	if input_array.has(last_direction):
		input_direction = last_direction
	
	#update gun aim
	%Gun.update_gun_aim(input_direction)
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()

	if Input.is_action_just_pressed("melee") and not attacking and not %Gun.shoot_mode:
		attack()
	
	if input_direction != Vector2.ZERO:
		last_direction = input_direction
	
	if attacking or %Gun.shoot_mode:
		input_direction = Vector2.ZERO
	
	#update animation
	update_animation(input_direction, Input.is_action_just_pressed("shoot"))


func _physics_process(_delta):

	#update velocity
	velocity = input_direction * speed
	
	#Move and Slide
	move_and_slide()


#Animation
func update_animation(move_input: Vector2, just_shot: bool = false):
	if attacking:
		return
	if %Gun.shoot_mode:
		sprite.flip_h = last_direction == Vector2.LEFT
		if sprite.animation == %Gun.animation_name and sprite.is_playing():
			return
		if not %Gun.can_shoot:
			return
		sprite.play(%Gun.animation_name)
		if not just_shot:
			sprite.pause()
		return
	sprite.flip_h = false
	if move_input == Vector2.ZERO:
		match last_direction:
			Vector2.RIGHT:
				sprite.play("idle_side")
			Vector2.LEFT:
				sprite.flip_h = true
				sprite.play("idle_side")
			Vector2.UP:
				sprite.play("idle_up")
			Vector2.DOWN:
				sprite.play("idle_down")
		return
	if abs(move_input.x) >= abs(move_input.y): # moving left-right faster than up-down
		sprite.play("walk_side")
		if move_input.x > 0:
			last_direction = Vector2.RIGHT
		else:
			sprite.flip_h = true
			last_direction = Vector2.LEFT
	else: # moving up-down faster than left-right
		if move_input.y > 0:
			sprite.play("walk_down")
			last_direction = Vector2.DOWN
		else:
			sprite.play("walk_up")
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
	all_interactions.append(area)
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
	#$AnimatedSprite2D.visible = not vis
	print("Toggling hide: ", sprite.visible)


func attack() -> void:
	attacking = true
	sprite.flip_h = false
	await weapon.attack(last_direction, sprite)
	await sprite.animation_finished
	sprite.offset = Vector2.ZERO
	attacking = false


func restore_ammo() -> void:
	#%Gun.reload()
	print("restoring")
	if %Gun.current_ammo < %Gun.MAX_AMMO:
		%Gun.current_ammo += 2


func die():
	death_sfx.play()
	Sanity.fill()
	get_tree().reload_current_scene()
