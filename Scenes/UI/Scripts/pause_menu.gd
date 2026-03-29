extends CanvasLayer

@onready var pause_button: Button = $Control/MarginContainer/HBoxContainer/PauseButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hide_menu()
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_show_menu()

func _show_menu() -> void:
	visible=true
	get_tree().paused=true
	if !pause_button.pressed.is_connected(_hide_menu): 
		pause_button.pressed.connect(_hide_menu)

func _hide_menu() -> void:
	if pause_button.pressed.is_connected(_hide_menu): 
		pause_button.pressed.disconnect(_hide_menu)
	visible=false
	get_tree().paused=false
