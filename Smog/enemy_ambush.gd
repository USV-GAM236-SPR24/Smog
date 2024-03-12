extends Enemy

@onready var timer: Timer = $Timer
@onready var player = $/root/Game/Player
@onready var Hurtbox = $root/Enemy_Ambush/Hurtbox/Hurtbox
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
		speed = 5
		damage = 2
		health = 1
	if player_chase == false:
		#
		#puddle animation
		#
		speed = 0
		damage = 0
	if position.distance_to(player.position) < 200: #If Player not in range, revert to puddle
		player_chase = false
		draining = false
		
	
		move_and_slide()
	if draining:
		drain_tick_progress += delta
		#
		#grapple animation
		#
		player.speed = 0
		if drain_tick_progress >= drain_tick_rate:
			Sanity.decrease(damage)
			drain_tick_progress -= drain_tick_rate
				
	

#chase player, grapple, chases player, reverts back to puddle if range is off screen


func die():
	player.speed = 100
	queue_free()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if player_chase == false:
			timer.start(1) #delay before ambush
			#animation here
			player_chase = true
			get_node(Hurtbox).disabled = false




func _on_hurtbox_body_entered(body):
	if body.name == "Player":
		draining = true


func _on_hurtbox_body_exited(body):
	if body.name == "Player":
		draining = false
		drain_tick_progress = drain_tick_rate
