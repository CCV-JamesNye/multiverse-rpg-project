extends CharacterBody2D

@export var patrol_speed: float = 135.0
var direction : Vector2 = Vector2.DOWN
var facing = "down"
enum state {IDLE, PATROL, CHASE}
var current_state : state = state.CHASE
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_detector: RayCast2D = $WallDetector

func _physics_process(delta: float) -> void:
	match current_state:
		state.IDLE:
			handle_idle()
		state.PATROL:
			handle_patrol()
		state.CHASE:
			handle_chase()
	
	move_and_collide(velocity * delta)
	if wall_detector.is_colliding():
		if direction == Vector2.DOWN:
			direction = Vector2.UP
			facing = "up"
			wall_detector.position.y = -15
			wall_detector.rotate(deg_to_rad(180))
		elif direction == Vector2.UP:
			direction = Vector2.DOWN
			facing = "down"
			wall_detector.position.y = 0
			wall_detector.rotate(deg_to_rad(180))

func handle_idle() -> void:
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
	pass

func handle_patrol() -> void:
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
	pass

func handle_chase() -> void:
	if facing == "down":
		animated_sprite_2d.play("run_down")
	elif facing == "up":
		animated_sprite_2d.play("run_up")
	elif facing == "right":
		animated_sprite_2d.play("run_side")
		animated_sprite_2d.flip_h = false
	elif facing == "left":
		animated_sprite_2d.play("run_side")
		animated_sprite_2d.flip_h = true
	velocity = direction * (patrol_speed * 2)
	pass
