extends Node

@export var plr_health : int

func plr_die():
	SceneTransition.save_scene()
	await SceneTransition.fade_to_black()
	if get_tree() != null:
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")
