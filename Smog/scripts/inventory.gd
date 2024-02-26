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
#          is_full() -> bool
#                 - returns true if all slots are full, false otherwise
class_name Inventory
extends Node2D


const SLOT_COUNT: int = 12

var inventory_slot_scene: PackedScene = preload("res://scenes/inventory/inventory_slot.tscn")

#index of currently selected slot in slots
var selectedPanelIndex: int = 0

#list of inventory slots
@onready var slots: Array = %GridContainer.get_children()


###  START TESTING
# T - add one opium instance
# F - add three cigarette instances
# G - example of using toggle() to toggle display of inventory
# J - move_selector_left()
# L - move_selector_right()
# K - use currently selected item use_item()

func _input(event: InputEvent) -> void:
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
		elif event.keycode == KEY_G:
			toggle()
		elif event.keycode == KEY_L:
			move_selector_right()
		elif event.keycode == KEY_J:
			move_selector_left()
		elif event.keycode == KEY_K:
			use_item()
#### END TESTING


func _enter_tree() -> void:
	for i: int in range(SLOT_COUNT):
		var inventory_slot: InventorySlot = inventory_slot_scene.instantiate()
		inventory_slot.name = "Slot " + str(i)
		%GridContainer.add_child(inventory_slot)


#toggle visibility
func toggle() -> void:
	self.visible = !self.visible


func move_selector_right() -> void:
	slots[selectedPanelIndex].toggle_selected()
	if(selectedPanelIndex + 1 < %GridContainer.get_child_count()):
		slots[selectedPanelIndex + 1].toggle_selected()
		selectedPanelIndex += 1
	else:
		selectedPanelIndex = 0
		slots[selectedPanelIndex].toggle_selected()


func move_selector_left() -> void:
	slots[selectedPanelIndex].toggle_selected()
	if( selectedPanelIndex > 0 ):
		slots[selectedPanelIndex - 1].toggle_selected()
		selectedPanelIndex -= 1
	elif selectedPanelIndex == 0:
		selectedPanelIndex = %GridContainer.get_child_count() - 1
		slots[selectedPanelIndex].toggle_selected()


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


func use_item() -> void:
	slots[selectedPanelIndex].use()


#setup window size change signal and
#set first slot as selected
func _ready() -> void:
	get_viewport().connect("size_changed", _on_window_resize)
	slots[selectedPanelIndex].toggle_selected()
	_on_window_resize()


#center inventory on window resize
func _on_window_resize() -> void:
	var window_size: Vector2 = get_viewport().size
	position = Vector2(window_size.x / 2, window_size.y - 64)
