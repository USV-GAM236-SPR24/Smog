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
	key_ring = get_node("/root/Game/CanvasLayer0/KeyRing")
	inventory = get_node("/root/Game/CanvasLayer/Inventory")
	item = ItemFactory.create(interact_value)
	interact_label = item.item_name.capitalize()
	$Sprite2D.texture = item.texture


func _interact() -> void:
	super._interact()
	item.name = "item_pickup"
	
	if interact_value == "key":
		item.type = Item.ItemType.KEYITEM
		key_ring._add_item(item)
		
	elif interact_value == "default":
		item.type = Item.ItemType.DEFAULT
		inventory.add_item(item)
		

