extends Weapon


var aim_direction: Vector2 = Vector2.ZERO
var gun_range: float = 250
var aim_mode: String = 'pad'
var endpoint: Vector2 = Vector2.ZERO
var unflipped: bool = true
var shoot_mode: bool = false


func _input(event) -> void:
	
	if Input.is_action_pressed("shoot_mode"):
		shoot_mode = true
	else:
		shoot_mode = false
	
	if event is InputEventMouse:
		aim_mode = 'mouse'
	elif event is InputEventJoypadMotion:
		aim_mode = 'pad'
		
		
func _process(_delta) -> void:
	$Marker2D/GunSprite.visible = shoot_mode
	
	
	if aim_mode == 'pad':
		aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		$Marker2D.look_at(aim_direction * gun_range - Vector2(0, -35))
	elif aim_mode == 'mouse':
		aim_direction = (get_global_mouse_position() - self.global_position).normalized()
		%Marker2D.look_at(get_global_mouse_position())
	
	endpoint = aim_direction * gun_range
	
	$RayCast2D.target_position = endpoint
	
	
	if Input.is_action_just_pressed("shoot"):
		_shoot()
		
		
	if _on_left():
		if unflipped:
			$Marker2D/GunSprite.scale *= Vector2(1, -1)
			unflipped = false
	else:
		if not unflipped:
			$Marker2D/GunSprite.scale *= Vector2(1, -1)
			unflipped = true
		
		
func _shoot() -> void:
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider is Enemy:
			collider._take_damage(1)


func _on_left() -> bool:
	return self.global_position.x - $Marker2D/GunSprite.global_position.x > 0
	
