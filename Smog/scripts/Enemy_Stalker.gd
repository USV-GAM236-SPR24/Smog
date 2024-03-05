extends CharacterBody2D

var speed = 10
var damage = 25

var draining = false
var drain_tick_rate = 0.5
var drain_tick_progress = drain_tick_rate


var player_chase = true
# ^^ his is under the assumption that the stalker will have a 'stalk' phase and thus not always be
#the snail of death


@onready var player = $/root/Game/Player



func _physics_process(delta):
	
	velocity = speed*position.direction_to(player.position)
	
	if position.distance_to(player.position) < 20:
		
		player_chase = true
	if player_chase:
		#position += (player.position - position)/speed 
		move_and_slide()
		
	if draining:
		drain_tick_progress += delta
		if drain_tick_progress >= drain_tick_rate:
			Sanity.decrease(damage)
			drain_tick_progress -= drain_tick_rate


func _on_area_2d_body_entered(body):
	print("Detected!")
	if body.name == "Player":
		player = body
		player_chase = true
		draining = true
#If player in zone, chase. If not, don't chase.



func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player = null
		player_chase = false
		draining = false
		drain_tick_progress = drain_tick_rate
