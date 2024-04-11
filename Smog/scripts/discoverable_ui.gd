extends CanvasLayer


@onready var text: Label = %DiscoverableText
@onready var title: Label = %DiscoverableName
@onready var exit: Label = %ExitLabel


func _input(event: InputEvent) -> void:
	if not exit.visible:
		return
	if event is InputEventJoypadButton or event is InputEventKey:
		exit_ui()


func set_from_discoverable(discoverable: Discoverable) -> void:
	text.text = discoverable.text
	title.text = discoverable.display_name


func set_and_enable(discoverable: Discoverable) -> void:
	set_from_discoverable(discoverable)
	visible = true
	get_tree().paused = true
	await get_tree().create_timer(1, true, false, true).timeout
	exit.visible = true


func exit_ui() -> void:
	visible = false
	get_tree().paused = false
	exit.visible = false
