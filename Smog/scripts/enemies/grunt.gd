extends Enemy


func _init() -> void:
	health = 2
	damage = 10
	speed = 15


func _ready() -> void:
	sprite = $AnimatedSprite2D
	detection_area = $DetectionArea2D
	nav_agent = $NavigationAgent2D
	death = $Death
	attack = $Attack
	super._ready()
	
