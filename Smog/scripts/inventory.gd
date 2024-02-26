# HOW TO USE:
#    add_item(item : Item) -> void 
#                     - to add an item to inventory
#        -- IMPORTANT - Item must have ITEM_TYPE to determine stacking
#                     - Item must have a use() function that applies its affects        
#    toggle() -> void 
#                 - toggles visibility of the inventory system
#
#        -- IMPORTANT - To use an item, click on it in the UI
class_name Inventory
extends Node2D


const SLOT_COUNT: int = 18

var inventory_slot_scene: PackedScene = preload("res://scenes/inventory_slot.tscn")

#list of inventory slots
@onready var slots: Array = %GridContainer.get_children()


func _enter_tree() -> void:
	for i in range(SLOT_COUNT):
		var new_slot: InventorySlot = inventory_slot_scene.instantiate()
		new_slot.name = "Slot " + str(i)
		new_slot.index = i
		%GridContainer.add_child(new_slot)


#toggle visibility
func toggle() -> void:
	self.visible = !self.visible


###  START TESTING
# T - add one opium instance
# F - add three cigarette instances
# G - example of using toggle() to toggle display of inventory

func _input(event : InputEvent) -> void:
	# EXAMPLE : adding a single instance of opium
	if event is InputEventKey and event.is_pressed(): 
		if event.keycode == KEY_T:
			var item_instance = ConsumableFactory.create("opium")
			add_item(item_instance)
		elif event.keycode == KEY_F: 
		# EXAMPLE : Making three new instances of cigarettes to add
			for i in range(3):
				var item2_instance = ConsumableFactory.create("cigarette")
				add_item(item2_instance)
		# EXAMPLE : Using toggle()
		elif event.keycode == KEY_G:
			toggle()
			

###  END TESTING


func _count_all_descendants(node : Node):
	var count = 0 
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		count += 1
		count += _count_all_descendants(child) 
	return count


func is_full() -> bool:
	for slot in slots:
		if not slot.full():
			return false
	
	return true


# NEEDS TO BE NEW INSTANCE OF THE ITEM THAT IS NOT ALREADY ADDED
func add_item(item : Item) -> void:
	if is_full():
		print("Inventory full!")
		return
	
	var has_existing_slot: bool = false
	var has_open_slot: bool = false
	for slot in slots:
		#has item
		if slot.item_count > 0:
			if slot.first_item.item_name == item.item_name:
				if not slot.full():
					slot.add_item(item)
					has_existing_slot = true
					break
	
	if not has_existing_slot:
		for slot in slots:
			if slot.item_count == 0:
				slot.add_item(item)
				has_open_slot = true
				break
		if not has_open_slot:
			print("Inventory full!")
			return


func use_item(index) -> void:
	slots[index].use()
