class_name Weapon
extends Node2D


@export var sprite_frames: SpriteFrames

var weapon_name: String
var damage: int

func _input(event):
	if event.is_action_pressed("melee"):
		pass
