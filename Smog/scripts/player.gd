extends CharacterBody2D
class_name Player

var direction

var SPEED = 160

func _physics_process(_delta) -> void:
	_update_raycast()
	
	direction = Input.get_vector("left", "right", "up", "down")
	
	if !(direction.x == 0.0 or direction.x == 1.0 or direction.x == -1.0):
		_update_anim()
		return
	
	velocity = direction * SPEED
	_update_anim()
	move_and_slide()
	
func _update_anim() -> void:
	
	match direction:
		Vector2.DOWN: %AnimationPlayer.play("forwards")
		Vector2.UP: %AnimationPlayer.play("up")
		Vector2.RIGHT: %AnimationPlayer.play("right")
		Vector2.LEFT: %AnimationPlayer.play("left")
		_: %AnimationPlayer.stop()


func _update_raycast():
	%RayCast2D.target_position = get_global_mouse_position()
	if %RayCast2D.is_colliding():
		var collider = %RayCast2D.get_collider()
		print(collider)
