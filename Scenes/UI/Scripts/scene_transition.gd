extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

func fade_to_black() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	return true

func fade_in() -> bool:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	return true
