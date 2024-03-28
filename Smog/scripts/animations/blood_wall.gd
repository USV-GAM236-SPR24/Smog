extends AnimatedSprite2D

@export var direction: Vector2 = Vector2.ZERO

var speed: float = 40

func _update_direction(input: Vector2):
	direction = input


func _process(delta):
	position += delta * direction * speed
	speed *= 0.99


func _ready() -> void:
	play("trigger")
	animation_finished.connect(idle)


func idle() -> void:
	play("idle")


#func _on_body_entered(body: Node2D) -> void:
	#if is_playing():
		#return
	#if body is Player:
		#trigger()

#func trigger() -> void:
	#if is_playing():
		#return
	#play("trigger")
#
