class_name Item
extends Node2D


enum ItemType {
	DEFAULT,
	CONSUMABLE,
	REUSABLE,
	UNSTACKABLE
}

var sprite: Sprite2D
@export var texture: Texture2D = preload("res://art/temp/item1.png")
@export var item_name := "item"
@export var type := ItemType.DEFAULT


func _enter_tree() -> void:
	sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	add_child(sprite)


func use():
	print('Item used!')


func is_unstackable():
	return type == ItemType.UNSTACKABLE
