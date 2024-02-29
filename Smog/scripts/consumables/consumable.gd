class_name Consumable
extends Item


@export var restore_power: int = 10


func _init(new_name: String = "consumable", new_restore_power: int = 10, new_texture: Texture2D = texture):
	type = ItemType.CONSUMABLE
	item_name = new_name
	restore_power = new_restore_power
	texture = new_texture


func use():
	Sanity.increase(restore_power)
	print("Restored " + str(restore_power) + " sanity!")
