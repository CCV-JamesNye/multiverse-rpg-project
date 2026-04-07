extends Control

@onready var start_play: Button = $"MarginContainer/Panel/MarginContainer/VBoxContainer/Start-Play"
@onready var quit_eject: Button = $"MarginContainer/Panel/MarginContainer/VBoxContainer/Quit-Eject"
@onready var hover: AudioStreamPlayer2D = $Hover
@onready var select: AudioStreamPlayer2D = $Select

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.fade_in()
	start_play.pressed.connect(_start_game)
	quit_eject.pressed.connect(_quit_game)
	pass # Replace with function body.

func _quit_game() -> void:
	select.play()
	await SceneTransition.fade_to_black()
	get_tree().quit()

func _start_game() -> void:
	select.play()
	await SceneTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/Worlds/Test World/test_level_1.tscn")
	pass
