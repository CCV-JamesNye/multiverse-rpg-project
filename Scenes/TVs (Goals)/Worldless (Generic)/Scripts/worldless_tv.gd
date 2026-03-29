extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detector: Area2D = $PlayerDetector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("default")
	player_detector.body_entered.connect(check_for_player)

func check_for_player(body : Node2D) -> void:
	if body is Player:
		await SceneTransition.fade_to_black()
		get_tree().change_scene_to_file("res://Scenes/UI/WinScreen.tscn")
