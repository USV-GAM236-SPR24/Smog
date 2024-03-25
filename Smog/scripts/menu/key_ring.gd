class_name KeyRing
extends Control

const MAX_ITEMS: int = 3

#key node references
var keys: Array[Node]

func _input(event: InputEvent):
	if not event is InputEventKey:
		return
	if not event.is_pressed():
		return
	
	if event.keycode == KEY_TAB:
		self.visible = not self.visible 


func use_key(_index: int):
	pass #TODO: implement this


func _add_item(item: Item) -> void:
	
	if not item.type == Item.ItemType.KEY or _full():
		print('Error: KeyRing.gd... _add_item(item: Item), item is not type KEY!')
		return
	
	for _panel in %GridContainer.get_children():
		if _panel.get_child_count() == 0:
			var TexNode: TextureRect = TextureRect.new()
			TexNode.texture = item.texture 
			_panel.add_child(TexNode)
			
			keys.append(item)
			return
			

func _full() -> bool:
	for panel in %GridContainer.get_children():
		if panel.get_child_count() == 0:
			return false
			
	return true
