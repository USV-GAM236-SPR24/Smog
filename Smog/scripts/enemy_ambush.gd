extends Enemy

@onready var timer: Timer = $Timer
@onready var Hurtbox = $Hurtbox/Hurtbox
var draining = false
var drain_tick_rate = .1
var drain_tick_progress = drain_tick_rate
var player_chase = false
var player: Player

func _init() -> void:
	speed = 0
	damage = 0
	health = 5


func _physics_process(delta):
	if not player:
		return

	if player_chase:
		#print("Chase!")
		$Animation.play("Chase")
		velocity = position.direction_to(player.position) * speed
		speed = 25
		damage = 2
		health = 1
		move_and_slide()

	if player_chase == false:
		#
		#print("Chase = False!")
		$Animation.play("Puddle")
		#get_node("Hurtbox/Hurtbox").disabled = true


	#if position.distance_to(player.position) > 200: #If Player not in range, revert to puddle
		#player_chase = false
		#draining = false

	if draining:
		drain_tick_progress += delta
		#
		#grapple animation
		#
		#player.speed = 0
		if drain_tick_progress >= drain_tick_rate:
			Sanity.decrease(damage)
			drain_tick_progress -= drain_tick_rate



#chase player, grapple, chases player, reverts back to puddle if range is off screen
func take_damage(delta):
	super._take_damage(delta)
	print(health)

func die():
	#player.speed = 100
	queue_free()


func _on_area_2d_body_entered(body):
	if body is Player:
		player = body
		if player_chase == false:
			print("detected!")
			$Animation.play("Emerge")
			timer.start(5) #delay before ambush
			player_chase = true

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
