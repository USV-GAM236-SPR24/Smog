extends Panel

const MAX_ITEMS = 16

@export var index : int

#if panel is full of items
func full() -> bool:
	if %items.get_child_count() == MAX_ITEMS:
		return true
	else:
		return false

#update UI text
func _update_counter():
	%itemCounter.text = str(get_child(0).get_child_count())

#update UI on ready
func _ready():
	_update_counter()

#call use() on item in %items and free it afterwards, then update counter
func use():
	if %items.get_child_count() > 0:
		var item = %items.get_child(0)
		item.use()
		item.queue_free()
		_update_counter()
	else:
		_update_counter()

#adds items to the panel, if more items are in panel than allowed
func add_item(item : Item):
	if get_child(0).get_child_count() + 1 <= MAX_ITEMS and item.get_parent() == null:
		%items.add_child(item)
	_update_counter()

#use item on panel when button pressed
func _on_button_pressed():
	use()
