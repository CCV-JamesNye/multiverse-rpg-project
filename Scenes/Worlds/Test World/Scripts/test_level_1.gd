extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.save_scene()
	SceneTransition.fade_in()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
