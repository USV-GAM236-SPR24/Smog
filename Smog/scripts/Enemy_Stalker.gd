extends Enemy


@onready var player = $/root/Game/World/Player
#@onready var rangedTimer = $"Ranged CD"
#@onready var RATKDelay = $RangedAtkDelay
#var Ranged = true #Whether or not the player is out of threshold to be Ranged
#var RangedAttackReady = false

var draining = false
var drain_tick_rate = 1
var drain_tick_progress = drain_tick_rate
var player_chase = true


#make sure if below stats are changed to change them on Die function too!!!

func _init() -> void:
	
	speed = 15
	damage = 15
	health = 5
	print(speed, damage, health)
 
func die():
	speed = 0
	damage = 0
	$Animation.play("Idle")
	await get_tree().create_timer(5.0).timeout
	speed = 15
	damage = 15
	health = 5
	#await get_tree().create_timer(5.0).timeout

func _physics_process(delta):
	if not player:
		return
	velocity = position.direction_to(player.position) * speed
	#Determines if should be in Ranged Mode
	
	#
	#if Ranged:
	#	speed = 35
	#	damage = 10
	#if Ranged == false:
	#	speed = 15
	#	damage = 15


#Ranged temporarily shut down for Beta
#	if ((position.distance_to(player.position) >= 90) && Ranged == false): #110 distance is effectively edge of screen
#		print("Ranged is true!")
#		$Animation.play("MtR")
#		await get_tree().create_timer(.6).timeout #Time for Animation to play
#		Ranged = true
#	if ((position.distance_to(player.position) <80)&& Ranged == true && RangedAttackReady == false):
#		print("Melee is true!")
#		$Animation.play ("RtM")
#		await get_tree().create_timer(.6).timeout #Time for Animation to play
		
#		Ranged = false
	if position.distance_to(player.position) < 300:
		player_chase = true
	if player_chase:
		#position += (player.position - position)/speed 
		move_and_slide()
		
	if draining:
		drain_tick_progress += delta
		
		if drain_tick_progress >= drain_tick_rate:
			Sanity.decrease(damage)
			drain_tick_progress -= drain_tick_rate
			
		#Attack Animation Code
		#ALL the following code has been removed:  && (Ranged == false) 
		if (velocity.x > 0 && (draining == true) && ((abs(velocity.y) < abs(velocity.x)))): #right MeleeStance
			$Animation.play("Atk LR")
			$Animation.flip_h = true
		if (velocity.x <= 0 && (draining == true) && ((abs(velocity.y) < abs(velocity.x)))): #left MeleeStance
			$Animation.play("Atk LR")
			$Animation.flip_h = false
		if (velocity.y >= 0  && (draining == true) && ((abs(velocity.y) > abs(velocity.x)))): #down Meleestance
			$Animation.play("Atk D")
			$Animation.flip_h = false
		if (velocity.y < 0  && (draining == true) && ((abs(velocity.y) > abs(velocity.x)))):
			$Animation.play("Atk U")
			$Animation.flip_h = false
	#Ranged Attack Code
	#if (Ranged == true && RangedAttackReady == true):
	#		#Ranged Animation
	#		$Animation.play("RAtk")
	#		print("Ranged Attack Ready!")
	#		await get_tree().create_timer(.75).timeout
	#		#Restart attack ready timer
	#		rangedTimer.start
	#		RangedAttackReady = false
			
	#Basic Movement Animations
	#Bottom lost && (Ranged == false)
	if (velocity.x > 0 && (draining == false)): #right MeleeStance
		$Animation.play("Melee LR")
		$Animation.flip_h = true
	if (velocity.x <= 0 && (draining == false)): #left MeleeStance
		$Animation.play("Melee LR")
		$Animation.flip_h = false

func _on_area_2d_body_entered(body):
	print("Detected!")
	if body.name == "Player":
		#player_chase = true #Player_chase might/should actually be unnecessary code
		draining = true
		#Ranged = false
#If player in zone, chase. If not, don't chase.

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		#player_chase = false
		draining = false
		drain_tick_progress = drain_tick_rate

#func _on_ranged_cd_timeout():
#	RangedAttackReady = true

#Ranged Attack Resolution
func _on_ranged_atk_delay_timeout():
	
	pass
