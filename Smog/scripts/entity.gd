class_name Entity
extends CharacterBody2D

var speed: int

func die():
	queue_free()
