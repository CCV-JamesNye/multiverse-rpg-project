extends CanvasLayer

@onready var menu_button: Button = $Control/MenuButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_button.pressed.connect(_menu)
	pass # Replace with function body.

func _menu() -> void:
	visible=false
	await SceneTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
