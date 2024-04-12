class_name Entity
extends CharacterBody2D

var speed: int

func die():
	#Remove ALL colission and visibility, wait 3 seconds, THEN execute queue_free
	#to allow for death sound effects
	queue_free()
