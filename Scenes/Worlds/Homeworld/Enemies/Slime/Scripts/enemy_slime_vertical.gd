extends CharacterBody2D

@export var patrol_speed: float = 180.0
var direction : Vector2 = Vector2.DOWN
var facing = "down"
enum state {IDLE, PATROL, CHASE}
var current_state : state = state.PATROL

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_detector: RayCast2D = $WallDetector
@onready var player_detector: Area2D = $PlayerDetector
@onready var chase_timer: Timer = $ChaseTimer
@onready var idle_timer: Timer = $IdleTimer

func _ready() -> void:
	player_detector.body_entered.connect(check_for_player)
	player_detector.body_exited.connect(player_left)
	chase_timer.timeout.connect(end_chase)
	idle_timer.timeout.connect(start_patrol)

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

func check_for_player(body : Node2D) -> void:
	if body is Player:
		chase_timer.stop()
		current_state = state.CHASE

func player_left(body : Node2D) -> void:
	if body is Player:
		idle_timer.stop()
		chase_timer.start()

func end_chase() -> void:
	current_state = state.IDLE
	idle_timer.start()

func start_patrol() -> void:
	current_state = state.PATROL
