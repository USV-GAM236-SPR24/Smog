class_name InventorySlot
extends Panel

const MAX_ITEMS = 16

var item_count: int = 0:
	set(value):
		item_count = value
		_update_counter()

#is item stack selected?
var selected = false

#call use() on item in %items and free it afterwards, then update counter
func use():
	if %items.get_child_count() > 0:
		var item = %items.get_child(0)
		item.use()
		item.queue_free()
		item_count -= 1
	else:
		print('Error: InventorySlot.use(), No items to use!')

#adds items to the panel, unless more items are in panel than allowed
func add_item(item: Item):
	if get_child(0).get_child_count() + 1 <= MAX_ITEMS and item.get_parent() == null:
		%items.add_child(item)
		item_count += 1

#if panel is full of items
func full() -> bool:
	if %items.get_child_count() == MAX_ITEMS:
		return true
	return false

#toggle selection visibility and local var
func toggle_selected():
	selected = not selected
	%selectImg.visible = selected

#update UI text
func _update_counter():
	%itemCounter.text = str(item_count)
	
#update UI on ready
func _ready():
	_update_counter()

#use item on panel when button pressed - REMOVED FEATURE FOR NOW
func _on_button_pressed():
	#use()
	pass

