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
extends Control


const SLOT_COUNT: int = 5

const ITEM_SLOT_GAP: int = 30

var inventory_slot_scene: PackedScene = preload("res://scenes/inventory/inventory_slot.tscn")

#index of currently selected slot in slots
var selected_panels_index: int = 0

var grabbing: bool = false

var _grab_index: int = 0

#list of inventory slots
@onready var slots: Array = %ItemSlots.get_children()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up"):
			move_selector_left()
	elif event.is_action_pressed("scroll_down"):
			move_selector_right()
	elif event.is_action_pressed("use_item"):
			use_item()
	elif event.is_action_pressed("item_grab"):
			grab_item()
			
	if not event is InputEventKey:
		return
	if not event.is_pressed():
		return
		
	match event.keycode:
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
			# EXAMPLE : adding a single instance of opium
			var consumable = ConsumableFactory.create("opium")
			add_item(consumable)
		KEY_7:
			# EXAMPLE : Making three new instances of cigarettes to add
			for i in range(3):
				var consumable = ConsumableFactory.create("cigarette")
				add_item(consumable)
		KEY_TAB:
			toggle()
			
			
#setup window size change signal and
#set first slot as selected
func _ready() -> void:
	get_viewport().connect("size_changed", _on_window_resize)
	slots[selected_panels_index].toggle_selected()
	_on_window_resize()


#center inventory on window resize
func _on_window_resize() -> void:
	var window_size: Vector2 = get_viewport_rect().size
	position = Vector2(window_size.x / 2, window_size.y - 16)


func _enter_tree() -> void:
	for i: int in range(SLOT_COUNT):
		var inventory_slot: InventorySlot = inventory_slot_scene.instantiate()
		inventory_slot.name = "Slot " + str(i)
		inventory_slot.index = i
		%ItemSlots.columns = SLOT_COUNT
		%ItemSlots.add_child(inventory_slot)


#toggle visibility
func toggle() -> void:
	visible = !visible
	print(visible)


#selection options
func num_swap(num: int) -> void:
	if num > SLOT_COUNT or num <= 0:
		return
	slots[selected_panels_index].toggle_selected()
	selected_panels_index = num - 1
	slots[selected_panels_index].toggle_selected()
	return
	
	
func move_selector_right() -> void:
	if grabbing:
		#hit last slot
		if _grab_index == SLOT_COUNT - 1:
			_grab_index = 0
			slots[selected_panels_index].position -= Vector2(ITEM_SLOT_GAP * SLOT_COUNT, 0)
		else:
			_grab_index += 1
		slots[selected_panels_index].position += Vector2(ITEM_SLOT_GAP, 0)
		return
	slots[selected_panels_index].toggle_selected()
	if(selected_panels_index + 1 < %ItemSlots.get_child_count()):
		slots[selected_panels_index + 1].toggle_selected()
		selected_panels_index += 1
	else:
		selected_panels_index = 0
		slots[selected_panels_index].toggle_selected()


func move_selector_left() -> void:
	if grabbing:
		#hit first slot
		if _grab_index == 0:
			_grab_index = SLOT_COUNT - 1
			slots[selected_panels_index].position += Vector2(ITEM_SLOT_GAP * SLOT_COUNT, 0)
		else:
			_grab_index -= 1
		slots[selected_panels_index].position -= Vector2(ITEM_SLOT_GAP, 0)
		return
	slots[selected_panels_index].toggle_selected()
	if( selected_panels_index > 0 ):
		slots[selected_panels_index - 1].toggle_selected()
		selected_panels_index -= 1
	elif selected_panels_index == 0:
		selected_panels_index = %ItemSlots.get_child_count() - 1
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
func _swap_children(index_a, index_b) -> void:
	var valid_index_b: bool = index_a >= 0 and index_b < %ItemSlots.get_child_count()
	var valid_index_a: bool = index_b >= 0 and index_b < %ItemSlots.get_child_count()
	if valid_index_b and valid_index_a and index_a != index_b:
		var child_a: InventorySlot = %ItemSlots.get_child(index_a)
		var child_b: InventorySlot = %ItemSlots.get_child(index_b)
		
		child_a.index = index_b
		child_b.index = index_a
		
		if child_a.selected:
			child_b.toggle_selected()
			child_a.toggle_selected() 
		elif child_b.selected:
			child_b.toggle_selected()
			child_a.toggle_selected() 
		
		%ItemSlots.move_child(child_a, index_b)
		%ItemSlots.move_child(child_b, index_a)
		
	slots = %ItemSlots.get_children()


func grab_item() -> void:
	#put item back down
	if grabbing:
		slots[selected_panels_index].position += Vector2(0, 10) 
		_swap_children(_grab_index, slots[selected_panels_index].index)
		num_swap(_grab_index + 1)
		grabbing = false
		return
	
	#pick item up if it has items
	if slots[selected_panels_index].item_count > 0:
		grabbing = true
		_grab_index = slots[selected_panels_index].index 
		slots[selected_panels_index].position -= Vector2(0, 10)
