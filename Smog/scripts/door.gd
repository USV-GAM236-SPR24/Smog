extends StaticBody2D

var player_entered = false

func _ready():
	$InteractLabel.visible = false

func open_door():
	#$AnimationPlayer.play() 
	#await $AnimationPlayer.animation_finished
	#$AnimationPlayer.play()
	#await $AnimationPlayer.animation_finished
	$player_detect/CollisionShape2D.disabled = true
	player_entered = false

func _on_player_detect_body_entered(body):
	if body.name == "Player":
		$InteractLabel.visible = true
		player_entered = true

func _on_player_detect_body_exited(body):
	if body.name == "Player":
		$InteractLabel.visible = false
		player_entered = false

func _input(_event):
	if Input.is_action_just_pressed("interact") && player_entered == true:
		open_door()









