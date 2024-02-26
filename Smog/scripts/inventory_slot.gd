class_name InventorySlot
extends Panel


const MAX_ITEMS = 16

var item_count: int = 0:
	set(value):
		item_count = value
		_update_counter()
@onready var items: Control:
	get:
		return get_child(0)
@onready var first_item: Item:
	get:
		return items.get_child(0)


#is item stack selected?
var selected = false

var pressed = false

var initial_items_position: Vector2
var intial_label_position: Vector2


func _process(delta):
	if pressed:
		if initial_items_position == Vector2.ZERO:
			initial_items_position = items.global_position
			intial_label_position = %itemCounter.global_position
		items.global_position = get_global_mouse_position() - get_global_rect().size / 2
		%itemCounter.global_position = items.global_position + Vector2(10, -10)
		return
	if initial_items_position != Vector2.ZERO:
		items.global_position = initial_items_position
		%itemCounter.global_position = intial_label_position

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
	
	items.add_child(item)
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
	%itemCounter.visible = item_count != 0


#update UI on ready
func _ready() -> void:
	_update_counter()


func _on_button_button_down():
	pressed = true

func _on_button_button_up():
	if pressed:
		for slot in get_parent().get_children():
			if self == slot:
				continue
			if slot.get_global_rect().has_point(get_global_mouse_position()):
				var temp_parent = Control.new()
				var temp_count = 0
				temp_count = item_count
				item_count = slot.item_count
				slot.item_count = temp_count
				for item in items.get_children():
					items.remove_child(item)
					temp_parent.add_child(item)
				for item in slot.items.get_children():
					slot.items.remove_child(item)
					items.add_child(item)
				for item in temp_parent.get_children():
					temp_parent.remove_child(item)
					slot.items.add_child(item)
					
	pressed = false
