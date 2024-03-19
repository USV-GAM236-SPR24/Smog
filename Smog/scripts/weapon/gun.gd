extends Weapon

const MAX_AMMO: int = 10

var aim_direction: Vector2 = Vector2.ZERO
var shoot_mode: bool = false
var flipped := false
var can_shoot := true

var current_ammo: int = MAX_AMMO:
	get:
		return current_ammo
	set(value):
		current_ammo = value
		_update_ammo_ui(value)

func reload() -> void:
	current_ammo = MAX_AMMO

func update_gun_aim(dir: Vector2) -> void:
	match dir:
		Vector2.UP:
			%Marker2D.rotation_degrees = 270
		Vector2.DOWN:
			%Marker2D.rotation_degrees = 90
		Vector2.RIGHT:
			%Marker2D.rotation_degrees = 0
		Vector2.LEFT:
			if not flipped:
				$Marker2D/GunSprite.scale *= Vector2(1, -1)
				flipped = true
			%Marker2D.rotation_degrees = 180


	aim_direction = dir


func _input(event) -> void:

	if Input.is_action_pressed("shoot_mode") and get_parent().can_poke:
		shoot_mode = true
	else:
		shoot_mode = false

	if Input.is_action_just_pressed("reload"):
		reload()


func _process(_delta) -> void:

	$Marker2D/GunSprite.visible = shoot_mode

	if Input.is_action_just_pressed("shoot") and can_shoot and get_parent().can_poke:
		_shoot() #dont shoot if caning

		await get_tree().create_timer(1).timeout
		can_shoot = true

func _shoot() -> void:
	if current_ammo == 0 || not shoot_mode || not can_shoot:
		return

	can_shoot = false

	current_ammo -= 1

	%AnimationPlayer.play("shoot")

	if $Marker2D/RayCast2D.is_colliding():
		var collider = $Marker2D/RayCast2D.get_collider()
		if collider is Enemy:
			collider._take_damage(1)

func _update_ammo_ui(value) -> void:
	var hudref: Control = get_node("/root/Game/CanvasLayer/WeaponHUD")
	hudref.ammo_amount = value
