# HOW TO USE:
#    add_item(item : Item) -> void 
#                     - to add an item to inventory
#        -- IMPORTANT - Item must have ITEM_TYPE to determine stacking
#                     - Item must have a use() function that applies its affects        
#    toggle() -> void 
#                 - toggles visibility of the inventory system
#
#        -- IMPORTANT - To use an item, click on it in the UI
extends Node2D

var item_scene : PackedScene = preload("res://scenes/items/item.tscn")
var item2_scene : PackedScene = preload("res://scenes/items/item_2.tscn")

#list of inventory slots
@onready var panels = %GridContainer.get_children()

#toggle visibility
func toggle() -> void:
	self.visible = !self.visible

###  START TESTING
# T - add one instance of item.tscn
# F - add three instances of item2.tscn
# G - example of using toggle() to toggle display of inventory

func _input(event : InputEvent) -> void:
	# EXAMPLE : adding a single item from item.tscn
	if event is InputEventKey and event.is_pressed(): 
		if event.keycode == KEY_T:
			var item_instance = item_scene.instantiate()
			add_item(item_instance)
		elif event.keycode == KEY_F: 
		# EXAMPLE : Making three new instances from item2.tscn to add
			for i in range(3):
				var item2_instance = item2_scene.instantiate()
				add_item(item2_instance)
		#EXAMPLE : Using toggle()
		elif event.keycode == KEY_G:
			toggle()
#### END TESTING


func _count_all_descendants(node : Node):
	var count = 0 
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		count += 1
		count += _count_all_descendants(child) 
	return count

func is_full() -> bool:
	var _full : bool = true
	
	for panel in panels:
		if !panel.full():
			_full = false
	
	return _full

# NEEDS TO BE NEW INSTANCE OF THE ITEM THAT IS NOT ALREADY ADDED
func add_item(item : Item) -> void:
	if is_full():
		print('Inventory full!')
	else:
		var found : bool = false
		for panel in panels:
			#has item
			if panel.get_child(0).get_child_count() > 0:
				if panel.get_child(0).get_child(0).ITEM_TYPE == item.ITEM_TYPE:
					if(!panel.full()): 
						panel.add_item(item)
						found = true
		if !found:
			var foundNewSlot : bool = false
			for panel in panels:
				if panel.get_child(0).get_child_count() == 0 and !foundNewSlot:
					panel.add_item(item)
					foundNewSlot = true
					
func use_item(index) -> void:
	panels[index].use()
