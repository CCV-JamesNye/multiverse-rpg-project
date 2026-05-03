extends Node2D
class_name WanderMarker

@onready var wander_marker: WanderMarker = $"."

@export var wander_id : int
enum enemy {LITTLE_CREACHER}
@export var enemy_type : enemy
var wander_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wander_position = wander_marker.global_position
	GameManager.wander_id_sent.connect(id_checker)

func id_checker():
	if GameManager.wander_id == wander_id:
		GameManager.wander_marker_position = wander_position
		GameManager.wander_id_received.emit()
		if enemy_type == enemy.LITTLE_CREACHER:
			GameManager.wander_enemy_type = "Little Creacher"
