# HOW TO USE:
#    add_item(item : Item) -> void
#                     - to add an item to inventory stack
#        -- IMPORTANT - Item must have a type to determine stacking
#                     - Item must have a use() function that applies its affects
#
#    use_item() -> void
#                 - calls use() on currently selected item
#
#    toggle() -> void
#                 - toggles visibility of the inventory system
#
#    move_selector_right() -> void
#                 - moves selected item in inventory to the right
#
#    move_selector_left() -> void
#                 - moves selected item in inventory to the left
#
#    is_full() -> bool
#                 - returns true if all slots are full, false otherwise
#
#    num_swap(num: int) -> void
#                 -swaps selected item to num
class_name Inventory
extends Node2D


const SLOT_COUNT: int = 9

var inventory_slot_scene: PackedScene = preload("res://scenes/inventory/inventory_slot.tscn")

#index of currently selected slot in slots
var selected_panels_index: int = 0

#list of inventory slots
@onready var slots: Array = %GridContainer.get_children()


###  START TESTING
# T - add one opium instance
# F - add three cigarette instances
# G - example of using toggle() to toggle display of inventory
# J - move_selector_left()
# L - move_selector_right()
# K - use currently selected item use_item()
# U - Test num_swap()
func _input(event: InputEvent) -> void:
	# EXAMPLE : adding a single instance of opium
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_0:
				num_swap(0)
			KEY_1:
				num_swap(1)
			KEY_2:
				num_swap(2)
			KEY_3:
				num_swap(3)
			KEY_4:
				num_swap(4)
			KEY_5:
				num_swap(5)
			KEY_6:
				num_swap(6)
			KEY_7:
				num_swap(7)
			KEY_8:
				num_swap(8)
			KEY_9:
				num_swap(9)
		if event.keycode == KEY_T:
			var item_instance = ConsumableFactory.create("opium")
			add_item(item_instance)
		elif event.keycode == KEY_F:
		# EXAMPLE : Making three new instances of cigarettes to add
			for i in range(3):
				var item2_instance = ConsumableFactory.create("cigarette")
				add_item(item2_instance)
		elif event.keycode == KEY_G:
			toggle()
		elif event.keycode == KEY_L:
			move_selector_right()
		elif event.keycode == KEY_J:
			move_selector_left()
		elif event.keycode == KEY_K:
			use_item()
#### END TESTING

#toggle visibility
func toggle() -> void:
	self.visible = !self.visible


#selection options
func num_swap(num: int) -> void:
	if num > SLOT_COUNT or num <= 0:
		return
	slots[selected_panels_index].toggle_selected()
	selected_panels_index = num - 1
	slots[selected_panels_index].toggle_selected()
	return
	
	
func move_selector_right() -> void:
	slots[selected_panels_index].toggle_selected()
	if(selected_panels_index + 1 < %GridContainer.get_child_count()):
		slots[selected_panels_index + 1].toggle_selected()
		selected_panels_index += 1
	else:
		selected_panels_index = 0
		slots[selected_panels_index].toggle_selected()


func move_selector_left() -> void:
	slots[selected_panels_index].toggle_selected()
	if( selected_panels_index > 0 ):
		slots[selected_panels_index - 1].toggle_selected()
		selected_panels_index -= 1
	elif selected_panels_index == 0:
		selected_panels_index = %GridContainer.get_child_count() - 1
		slots[selected_panels_index].toggle_selected()


#true if all slots in slots are full
func is_full() -> bool:
	for slot: InventorySlot in slots:
		if not slot.full():
			return false

	return true


# NEEDS TO BE NEW INSTANCE OF THE ITEM THAT IS NOT ALREADY ADDED
func add_item(item: Item) -> void:
	if is_full():
		print('Inventory full!')
		return
	var found := false

	#checking for similar stacks
	for slot: InventorySlot in slots:
		#has item
		if slot.item_count > 0:
			if slot.first_item.item_name == item.item_name:
				if not slot.full():
					slot.add_item(item)
					found = true
					break
	if not found:
		var foundNewSlot := false
		for slot in slots:
			if slot.item_count == 0 and not foundNewSlot:
				slot.add_item(item)
				foundNewSlot = true
				break


#use currently selected item
func use_item() -> void:
	slots[selected_panels_index].use()


#swaps grid container children (InventorySlots) by index
func swap_children(index_a, index_b):
	var valid_index_b: bool = index_a >= 0 and index_b < %GridContainer.get_child_count()
	var valid_index_a: bool = index_b >= 0 and index_b < %GridContainer.get_child_count()
	if valid_index_b and valid_index_a and index_a != index_b:
		var child_a: InventorySlot = %GridContainer.get_child(index_a)
		var child_b: InventorySlot = %GridContainer.get_child(index_b)
		
		child_a.index = index_b
		child_b.index = index_a
		
		if child_a.selected:
			child_b.toggle_selected()
			child_a.toggle_selected() 
		elif child_b.selected:
			child_b.toggle_selected()
			child_a.toggle_selected() 
		
		%GridContainer.move_child(child_a, index_b)
		%GridContainer.move_child(child_b, index_a)
		
	slots = %GridContainer.get_children()
	
	
#setup window size change signal and
#set first slot as selected
func _ready() -> void:
	get_viewport().connect("size_changed", _on_window_resize)
	slots[selected_panels_index].toggle_selected()
	_on_window_resize()


#center inventory on window resize
func _on_window_resize() -> void:
	var window_size: Vector2 = get_viewport().size
	position = Vector2(window_size.x / 2, window_size.y - 64)


func _enter_tree() -> void:
	for i: int in range(SLOT_COUNT):
		var inventory_slot: InventorySlot = inventory_slot_scene.instantiate()
		inventory_slot.name = "Slot " + str(i)
		inventory_slot.index = i
		%GridContainer.add_child(inventory_slot)
