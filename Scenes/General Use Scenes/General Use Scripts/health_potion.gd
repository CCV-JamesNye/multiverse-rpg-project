extends Area2D

@onready var health_potion: Area2D = $"."

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.player_heal.emit()
		health_potion.queue_free()
