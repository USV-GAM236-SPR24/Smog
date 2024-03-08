extends Enemy

@onready var timer: Timer = $Timer
@onready var player = $/root/Game/Player
var draining = false
var drain_tick_rate = .1
var drain_tick_progress = drain_tick_rate
var player_chase = false

func _init() -> void:
	speed = 0
	damage = 0
	health = 5

func _physics_process(delta):
	if not player:
		return
	if player_chase:
		move_and_slide()
	if draining:
		drain_tick_progress += delta
		if drain_tick_progress >= drain_tick_rate:
			Sanity.decrease(damage)
			drain_tick_progress -= drain_tick_rate

#chase player, grapple, chases player, reverts back to puddle if range is off screen



func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if player_chase == false:
			timer.start(1) #delay before ambush
			#animation here
			player_chase = true
