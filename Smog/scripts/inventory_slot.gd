class_name InventorySlot
extends Panel


const MAX_ITEMS = 16

var item_count: int = 0:
	set(value):
		item_count = value
		_update_counter()

@onready var first_item: Item:
	get:
		return %items.get_child(0)

@export var index : int


#update UI on ready
func _ready():
	_update_counter()


#if panel is full of items
func full() -> bool:
	if item_count >= MAX_ITEMS:
		return true
	if item_count > 0:
		if first_item.is_unstackable():
			return true
	
	return false


#update UI text
func _update_counter():
	%itemCounter.text = str(item_count)


#call use() on item in %items and free it afterwards, then update counter
func use():
	if item_count > 0:
		first_item.use()
		if not first_item.type == Item.ItemType.REUSABLE:
			item_count -= 1
			first_item.queue_free()


#adds items to the panel, if more items are in panel than allowed
func add_item(item: Item) -> void:
	if item.get_parent() != null:
		return
	if item_count >= MAX_ITEMS:
		return
	if item_count > 0:
		if first_item.is_unstackable():
			return
	
	%items.add_child(item)
	item_count += 1


#use item on panel when button pressed
func _on_button_pressed():
	use()
