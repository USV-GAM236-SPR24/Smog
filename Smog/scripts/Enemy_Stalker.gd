extends Enemy

@onready var timer: Timer = $Timer
@onready var player = $/root/Game/Player

var StunTime = 5
var draining = false
var drain_tick_rate = 1
var drain_tick_progress = drain_tick_rate
var player_chase = true

func _init() -> void:
	speed = 5	
	damage = 25
	health = 5

func die():
	speed = 0
	damage = 0
	timer.start(StunTime) 


func _on_timer_timeout():
	speed = 7
	damage = 25
	health = 5

func _physics_process(delta):
	if not player:
		return
	velocity = speed*position.direction_to(player.position)

	
	if position.distance_to(player.position) < 100:
		
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
		player_chase = true
		draining = true
#If player in zone, chase. If not, don't chase.



func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_chase = false
		draining = false
		drain_tick_progress = drain_tick_rate

