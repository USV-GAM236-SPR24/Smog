class_name InventorySlot
extends Panel


const MAX_ITEMS = 16

var item_count: int = 0:
	set(value):
		item_count = value
		_update_counter()
var first_item: Item:
	get:
		return %items.get_child(0)

#is item stack selected?
var selected = false

var pressed = false

@onready var collision_rect := Rect2(position, size*scale)

func _process(delta):
	if pressed:
		global_position = get_global_mouse_position()

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
	selected = not selected
	%selectImg.visible = selected


#update UI text
func _update_counter() -> void:
	%itemCounter.text = str(item_count)


#update UI on ready
func _ready() -> void:
	_update_counter()
	print(collision_rect)


func _on_button_button_down():
	pressed = true

func _on_button_button_up():
	
	var smallest: float = INF
	var smallesSlot: InventorySlot = self
	
	if pressed:
		for slot in get_parent().get_children():
			var dist = self.global_position.distance_to(slot.global_position)
			if self == slot:
				continue
			if dist < 20:
				print(slot.name)
				break
	pressed = false
