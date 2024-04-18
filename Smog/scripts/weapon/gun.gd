extends Weapon

const MAX_AMMO: int = 10

var aim_direction: Vector2 = Vector2.ZERO
var shoot_mode: bool = false
var flipped := false
var can_shoot := true

var animation_name: String = "shoot_side"

var current_ammo: int = MAX_AMMO:
	get:
		return current_ammo
	set(value):
		current_ammo = max(min(value, MAX_AMMO), 0)
		_update_ammo_ui(value)

func reload() -> void:
	current_ammo = MAX_AMMO

func update_gun_aim(dir: Vector2) -> void:
	
	match dir:
		Vector2.UP:
			animation_name = "shoot_up"
			%Marker2D.rotation_degrees = 270
		Vector2.DOWN:
			animation_name = "shoot_down"
			%Marker2D.rotation_degrees = 90
		Vector2.RIGHT:
			animation_name = "shoot_side"
			%Marker2D.rotation_degrees = 0
		Vector2.LEFT:
			animation_name = "shoot_side"
			%Marker2D.rotation_degrees = 180


	aim_direction = dir


func _input(_event) -> void:

	if Input.is_action_pressed("shoot_mode") and not get_parent().attacking:
		shoot_mode = true
	else:
		shoot_mode = false

	if Input.is_action_just_pressed("reload"):
		reload()


func _process(_delta) -> void:

	if Input.is_action_just_pressed("shoot") and can_shoot and not get_parent().attacking:
		_shoot() #dont shoot if attacking

		await get_tree().create_timer(1).timeout
		can_shoot = true

func _shoot() -> void:
	if current_ammo == 0 || not shoot_mode || not can_shoot:
		return

	can_shoot = false

	current_ammo -= 1

	var collider = $Marker2D/RayCast2D.get_collider()
	if not collider:
		return
	if collider.get_parent() is Enemy:
		collider.get_parent()._take_damage(1)
	elif collider is Enemy:
		collider._take_damage(1)

func _update_ammo_ui(value) -> void:
	var hudref: Control = get_node("/root/Game/CanvasLayer/WeaponHUD")
	if hudref:
		hudref.ammo_amount = value
