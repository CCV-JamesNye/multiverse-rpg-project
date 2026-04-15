extends Node

@export var plr_health : int
signal any_button_pressed
var button_id : int

func plr_die():
	SceneTransition.save_scene()
	await SceneTransition.fade_to_black()
	if get_tree() != null:
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")
