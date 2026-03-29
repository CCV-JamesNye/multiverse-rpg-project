extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
const GAME_OVER = preload("uid://hev03nnsgdno")
const MAIN_MENU = preload("uid://dne06jddya6i8")
const PAUSE_MENU = preload("uid://bmx4li7f6uhvk")
var saved_scene

func save_scene() -> bool:
	saved_scene = get_tree().current_scene.scene_file_path
	return true

func fade_to_black() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	return true

func fade_in() -> bool:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	return true
