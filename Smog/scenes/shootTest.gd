extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Changes text when button is pressed.
func onClick():
	var placeholder_hp = 100
	var damage = 100
	
	%Button.text = "shooting"
	placeholder_hp -= damage
	
	if (placeholder_hp == 0):
		%Button.queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
