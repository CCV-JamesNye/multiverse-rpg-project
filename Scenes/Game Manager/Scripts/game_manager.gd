extends Node

@export var plr_health : int
signal any_button_pressed
var button_id : int
signal red_blue_button_pressed
signal red_blue_pressed_2
var red_button_pressed : bool
var blue_button_pressed : bool

func _process(delta: float) -> void:
	red_blue_button_pressed.connect(send_button_press)

func send_button_press():
	red_blue_pressed_2.emit()

func plr_die():
	SceneTransition.save_scene()
	await SceneTransition.fade_to_black()
	if get_tree() != null:
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")
