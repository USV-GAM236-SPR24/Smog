class_name KeyRing
extends Control

@onready var items: Array[Node] = %GridContainer.get_children():
	get:
		return %GridContainer.get_children()
		
		
func _ready():
	pass#_add_item()
	
	
func _add_item(item: Item):
	if item.ItemType == Item.ItemType:
		pass 
