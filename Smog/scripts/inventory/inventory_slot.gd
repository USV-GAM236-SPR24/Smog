class_name InventorySlot
extends Panel

const PICKUP_RANGE = 40

const MAX_ITEMS = 16

@export var index : int 

var item_count: int = 0:
	set(value):
		item_count = value
		_update_counter()
		
var first_item: Item:
	get:
		return %items.get_child(0)

#is item stack selected?
var selected = false

#is item being pressed?
var pressed = false

#original position of slot before being dragged
var slot_set_pos: Vector2
# offset when grabbing item
var grab_offset: Vector2


#update UI on ready
func _ready() -> void:
	_update_counter()


#while pressed attatch to mouse
func _process(_delta):
	if pressed:
		self.global_position = get_global_mouse_position() + grab_offset


#call use() on item in %items and free it afterwards, then update counter
func use() -> void:
	if item_count == 0:
		print('Error: InventorySlot.use(), No items to use!')
		return
	
	first_item.use()
	first_item.queue_free()
	item_count -= 1


#adds items to the panel, unless more items are in panel than allowed
func add_item(item: Item) -> void:
	if item.get_parent() != null:
		return
	if item_count >= MAX_ITEMS:
		return
	
	%items.add_child(item)
	item_count += 1


#if panel is full of items
func full() -> bool:
	if item_count == MAX_ITEMS:
		return true
	if item_count == 1:
		if first_item.is_unstackable():
			return true
	return false


#toggle selection visibility and local var
func toggle_selected() -> void:
	
	var current_inv_select_sprite = get_parent().get_parent().find_child("GridContainer2").get_child(index).get_child(0)
	
	selected = not selected
	#%selectImg.visible = selected
	if selected:
		current_inv_select_sprite.visible = true
	else:
		current_inv_select_sprite.visible = false


#update UI text
func _update_counter() -> void:
	%itemCounter.text = str(item_count)
	if item_count == 0:
		%itemCounter.visible = false
	else:
		%itemCounter.visible = true


#when item selected (and has items), pressed set true
func _on_button_button_down() -> void:
	if pressed:
		return
	if item_count == 0:
		return
	pressed = true
	slot_set_pos = self.global_position
	grab_offset = global_position - get_global_mouse_position()


#when item unselected (and was previously selected ), swap item with closest slot,
# then pressed set false
func _on_button_button_up() -> void:
	if item_count == 0:
		return
	
	pressed = false
	
	for slot in get_parent().get_children():
		if slot == self:
			continue
		
		if slot.get_global_rect().has_point(get_global_mouse_position()):
			get_parent().get_parent().swap_children(self.index, slot.index)
			return
	
	global_position = slot_set_pos
