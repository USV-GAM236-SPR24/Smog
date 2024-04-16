extends TextureProgressBar


const ICON_STEP: int = int(Sanity.MAXIMUM / 8)

@onready var icon: TextureRect = $SanityIcon


func _enter_tree() -> void:
	Sanity.sanity_changed.connect(_on_sanity_changed)
	

func _ready() -> void:
	value = Sanity.current


func _on_sanity_changed(_old: float, new: float) -> void:
	value = new
	update_icon()


func update_icon() -> void:
	var icon_index: int = 9 - (value / ICON_STEP)
	print(icon_index % 3 * 16)
	icon.texture.region = Rect2i(icon_index % 3 * 16, icon_index / 3 * 16, 16, 16)
