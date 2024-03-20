class_name KeyRing
extends Control

const MAX_ITEMS: int = 3


func _add_item(item: Item) -> void:
	
	if not item.type == int(Item.ItemType.KEYITEM) or _full():
		print('Error: KeyRing.gd... _add_item(item: Item), item is not type KEYITEM!')
		return
	
	for _item in %GridContainer.get_children():
		if _item.get_child_count() == 0:
			_item.add_child(item)
			return
	

func _full() -> bool:
	for panel in %GridContainer.get_children():
		if panel.get_child_count() == 0:
			return false
			
	return true
