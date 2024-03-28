extends Enemy


var emerged := false


func _init() -> void:
	health = 1
	damage = 20
	speed = 25


func _ready() -> void:
	sprite = $AnimatedSprite2D
	detection_area = $DetectionArea2D
	nav_agent = $NavigationAgent2D
	super._ready()
	sprite.play("puddle")


func update_animation() -> void:
	if not emerged:
		dirty_animation = false
		return
	super.update_animation()


func _on_body_entered(body: Node) -> void:
	if not emerged and body is Player:
		sprite.play("emerge")
		await sprite.animation_finished
		emerged = true
	super._on_body_entered(body)

