# HOW TO USE:
#    add_item(item : Item) -> void 
#                     - to add an item to inventory
#        -- IMPORTANT - Item must have ITEM_TYPE to determine stacking
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
extends Node2D

#example item scenes
var item_scene : PackedScene = preload("res://scenes/inventory/temp/item.tscn")
var item2_scene : PackedScene = preload("res://scenes/inventory/temp/item_2.tscn")

#index of currently selected panel in panels
var selectedPanelIndex = 0

#list of inventory slots
@onready var panels = %GridContainer.get_children()


###  START TESTING
# T - add one instance of item.tscn
# F - add three instances of item2.tscn
# G - example of using toggle() to toggle display of inventory
# J - move_selector_left()
# L - move_selector_right()
# K - use currently selected item use_item()

func _input(event : InputEvent) -> void:
	# EXAMPLE : adding a single item from item.tscn
	if event is InputEventKey and event.is_pressed(): 
		if event.keycode == KEY_T:
			var item_instance = item_scene.instantiate()
			add_item(item_instance)
		elif event.keycode == KEY_F: 
			for i in range(3):
				var item2_instance = item2_scene.instantiate()
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
	
func move_selector_right() -> void:
	panels[selectedPanelIndex].toggle_selected()
	if(selectedPanelIndex + 1 < %GridContainer.get_child_count()):
		panels[selectedPanelIndex + 1].toggle_selected()
		selectedPanelIndex += 1
	else:
		selectedPanelIndex = 0
		panels[selectedPanelIndex].toggle_selected()
		
func move_selector_left() -> void:
	panels[selectedPanelIndex].toggle_selected()
	if( selectedPanelIndex > 0 ):
		panels[selectedPanelIndex - 1].toggle_selected()
		selectedPanelIndex -= 1
	elif selectedPanelIndex == 0:
		selectedPanelIndex = %GridContainer.get_child_count() - 1
		panels[selectedPanelIndex].toggle_selected()

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
		
		#checking for similar stacks
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
func use_item() -> void:
	panels[selectedPanelIndex].use()
	
#setup window size change signal and
#set first slot as selected
func _ready():
	get_viewport().connect("size_changed", _on_window_resize)
	panels[selectedPanelIndex].toggle_selected()
	_on_window_resize()

#center inventory on window resize
func _on_window_resize() -> void:
	var window_size = get_viewport().size
	position = Vector2(window_size.x / 2, window_size.y - 20)
