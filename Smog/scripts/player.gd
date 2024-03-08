class_name Player
extends Entity


var last_direction: Vector2 = Vector2.RIGHT
var shoot_range = 500
var shooting_mode := false
var _aim_input_mode: bool # 0 for mouse , 1 for pad
var aim_dir

@export var player_acceleraction : float = 10

@onready var all_interactions = []
@onready var interactLabel = $"Interaction Components/InertactLabel"


func _enter_tree() -> void:
	$"Interaction Components/InteractionArea".area_entered.connect(_on_interaction_area_area_entered)
	$"Interaction Components/InteractionArea".area_exited.connect(_on_interaction_area_area_exited)
	Sanity.sanity_empty.connect(die)
	speed = 100


func _ready():
	$AnimatedSprite2D.play("idle_right")
	update_interactions()


func _process(_delta):
	
	#true if to the left
	if _gun_side():
			$RayCast2D/GunPivot/Sprite2D.scale = Vector2(1, -1)
	else:
			$RayCast2D/GunPivot/Sprite2D.scale = Vector2(1, 1)
	
	if shooting_mode and !aim_dir == Vector2.ZERO:
		%GunPivot.look_at($RayCast2D.target_position)
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	
	if Input.is_action_just_pressed("shoot") and shooting_mode:
		if not $RayCast2D.is_colliding():
			return
		var collider = $RayCast2D.get_collider()
		if collider is Enemy:
			#print("hit", $RayCast2D.target_position.normalized())
			collider.death_angle = $RayCast2D.target_position.normalized()
			collider._on_shoot()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$RayCast2D.target_position = get_local_mouse_position().normalized() * shoot_range
		_aim_input_mode = 0
	if event is InputEventJoypadMotion:
		aim_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		$RayCast2D.target_position = self.global_position + (aim_dir * shoot_range)
		_aim_input_mode = 1
	
	if event.is_action("shoot_mode"):
		shooting_mode = event.is_action_pressed("shoot_mode")


func _physics_process(_delta):

	#get input direction
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
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
	

func _gun_side() -> bool:
	return self.global_position.x - $RayCast2D/GunPivot/Sprite2D.global_position.x > 0

