extends CanvasLayer

@onready var menu_button: Button = $Control/MenuButton
@onready var restart_button: Button = $Control/RestartButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.fade_in()
	menu_button.pressed.connect(menu)
	restart_button.pressed.connect(restart)
	pass # Replace with function body.

func menu() -> void:
	visible = false
	await SceneTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")

func restart() -> void:
	visible = false
	await SceneTransition.fade_to_black()
	get_tree().change_scene_to_file(SceneTransition.saved_scene)
