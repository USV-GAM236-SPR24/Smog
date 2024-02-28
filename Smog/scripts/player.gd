extends CharacterBody2D
class_name Player

var direction

var SPEED = 160

func _physics_process(_delta) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
	#exclude sideways movement
	if !(direction.x == 0.0 or direction.x == 1.0 or direction.x == -1.0):
		return
	
	velocity = direction * SPEED
	_update_anim()
	move_and_slide()
	
func _update_anim() -> void:
	
	if direction == Vector2.ZERO:
		%AnimationPlayer.stop()
		return
	
	match direction:
		Vector2.DOWN: %AnimationPlayer.play("forwards")
		Vector2.UP: %AnimationPlayer.play("up")
		Vector2.RIGHT: %AnimationPlayer.play("right")
		Vector2.LEFT: %AnimationPlayer.play("left")
