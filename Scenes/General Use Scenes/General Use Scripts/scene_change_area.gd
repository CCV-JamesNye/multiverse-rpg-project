extends Area2D

@export var connected_room : String
@export var player_positon : Vector2

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		RoomChangeHandler.activate = true
		RoomChangeHandler.player_position = player_positon
		get_tree().call_deferred("change_scene_to_file", connected_room)
