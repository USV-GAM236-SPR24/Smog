class_name Entity
extends CharacterBody2D

var speed: float

func die():
	queue_free()
