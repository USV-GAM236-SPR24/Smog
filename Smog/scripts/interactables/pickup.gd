extends Interactable

var key_ring: KeyRing
var inventory: Inventory
var item: Item

@export var item_name: String


func _enter_tree() -> void:
	interact_type = InteractType.PICKUP
	is_single_use = true
	interact_value = item_name


func _ready() -> void:
	key_ring = get_node("/root/Game/CanvasLayer/KeyRing")
	inventory = get_node("/root/Game/InventoryLayer/Inventory")
	item = ItemFactory.create(interact_value)
	interact_label = item.item_name.capitalize()
	$Sprite2D.texture = item.texture


func _interact() -> void:
	if interact_value == "key":
		is_single_use = false
		
		if not key_ring._full():
			is_single_use = true
			item.type = Item.ItemType.KEY
			key_ring._add_item(item)
		
	if interact_value == "default":
		item.type = Item.ItemType.DEFAULT
	inventory.add_item(item)
