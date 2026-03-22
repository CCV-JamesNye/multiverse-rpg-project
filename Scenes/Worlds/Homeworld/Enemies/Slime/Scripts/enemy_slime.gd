extends CharacterBody2D

@export var patrol_speed: float = 50.0
var facing = "none"
enum state {IDLE, PATROL, CHASE}
var current_state : state = state.IDLE
func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)
