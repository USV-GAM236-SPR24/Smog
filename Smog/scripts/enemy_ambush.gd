extends Enemy

@onready var timer: Timer = $Timer
@onready var Hurtbox = $Hurtbox/Hurtbox
var draining = false
var drain_tick_rate = .1
var drain_tick_progress = drain_tick_rate
var player_chase = false
var detected = false
var player: Player

func _init() -> void:
	speed = 0
	damage = 0
	health = 3


func _physics_process(delta):
	#if not player:
		#return
	if player_chase:
		print("Chase!")
		
		velocity = position.direction_to(player.position) * speed
		speed = 25
		damage = 2
		health = 1
		
		if (velocity.x > 0 && (abs(velocity.y) < abs(velocity.x)) && (draining == false)): #right
			$Animation.play("Chase R")
			$Animation.flip_h = false
		if (velocity.x <= 0 && (abs(velocity.y) < abs(velocity.x)) && (draining == false)): #left
			$Animation.play("Chase R")
			$Animation.flip_h = true
			
		if (velocity.y >= 0 && (abs(velocity.y) > abs(velocity.x)) && (draining == false)): #down
			$Animation.play("Chase D")
			$Animation.flip_h = false
		if (velocity.y < 0 && (abs(velocity.y) > abs(velocity.x)) && (draining == false)): #up
			$Animation.play("Chase U")
			$Animation.flip_h = false
		move_and_slide()
	

	if (player_chase == false && detected == false):
		
		$Animation.play("Puddle")
		#get_node("Hurtbox/Hurtbox").disabled = true
		
		
	#if position.distance_to(player.position) > 200: #If Player not in range, revert to puddle
		#player_chase = false
		#draining = false
		
	if draining:
		player.speed = 30
		if (velocity.x > 0 && (abs(velocity.y) < abs(velocity.x))): #right
			$Animation.play("Atk R")
			
		if (velocity.x <= 0 && (abs(velocity.y) < abs(velocity.x))): #left
			$Animation.play("Atk R")
			
			
		if (velocity.y >= 0 && (abs(velocity.y) > abs(velocity.x))): #down
			$Animation.play("Atk D")
			
		if (velocity.y < 0 && (abs(velocity.y) > abs(velocity.x))): #up
			$Animation.play("Atk U")
		
		
		drain_tick_progress += delta
		#
		#grapple animation
		#
		#player.speed = 0
		if drain_tick_progress >= drain_tick_rate:
			Sanity.decrease(damage)
			drain_tick_progress -= drain_tick_rate
				
	

#chase player, grapple, chases player, reverts back to puddle if range is off screen


func die():
	player.speed = 100
	queue_free()


func _on_area_2d_body_entered(body):
	if body is Player:
		player = body
		if player_chase == false:
			detected = true
			print("detected!")
			$Animation.play("Emerge")
			timer.start(1) #delay before ambush
			
			
			#get_node("Hurtbox/Hurtbox").disabled = false


func _on_hurtbox_body_entered(body):
	if body.name == "Player":
		player = body
		draining = true


func _on_hurtbox_body_exited(body):
	if body.name == "Player":
		player = body
		draining = false
		drain_tick_progress = drain_tick_rate
		player.speed = 100
		



func _on_timer_timeout():
	player_chase = true
