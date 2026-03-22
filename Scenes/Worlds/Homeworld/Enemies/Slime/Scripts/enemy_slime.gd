extends CharacterBody2D

@export var patrol_speed: float = 150.0
var direction : Vector2 = Vector2.LEFT
var facing = "down"
enum state {IDLE, PATROL, CHASE}
var current_state : state = state.PATROL
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)

func _process(_delta: float) -> void:
	if current_state == state.IDLE:
		if facing == "down":
			animated_sprite_2d.play("idle_down")
		elif facing == "up":
			animated_sprite_2d.play("idle_up")
		elif facing == "right":
			animated_sprite_2d.play("idle_side")
			animated_sprite_2d.flip_h = false
		elif facing == "left":
			animated_sprite_2d.play("idle_side")
			animated_sprite_2d.flip_h = true
		velocity=Vector2.ZERO
	elif current_state == state.PATROL:
		if facing == "down":
			animated_sprite_2d.play("walk_down")
		elif facing == "up":
			animated_sprite_2d.play("walk_up")
		elif facing == "right":
			animated_sprite_2d.play("walk_side")
			animated_sprite_2d.flip_h = false
		elif facing == "left":
			animated_sprite_2d.play("walk_side")
			animated_sprite_2d.flip_h = true
		velocity = direction * patrol_speed
