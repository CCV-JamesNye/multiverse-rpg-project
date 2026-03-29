extends CanvasLayer

@onready var return_button: Button = $Control/ReturnButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return_button.pressed.connect(return_to_menu)

func return_to_menu() -> void:
	visible = false
	await SceneTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
