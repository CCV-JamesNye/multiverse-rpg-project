extends CharacterBody2D
class_name IdleChaser

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detector: Area2D = $PlayerDetector
@onready var chase_timer: Timer = $ChaseTimer
@onready var idle_timer: Timer = $IdleTimer

@export var patrol_speed: float = 110.0
var direction : Vector2 = Vector2.DOWN
var facing = "down"
enum state {IDLE, PATROL, CHASE, START}
var current_state : state = state.IDLE
var player_target = Player
@onready var start_position

func _ready() -> void:
	player_target = get_tree().get_first_node_in_group("player")
	start_position = collision_shape_2d.global_position
	player_detector.body_entered.connect(check_for_player)
	player_detector.body_exited.connect(player_left)
	chase_timer.timeout.connect(end_chase)
	idle_timer.timeout.connect(return_to_start)

func _physics_process(delta: float) -> void:
	match current_state:
		state.IDLE:
			handle_idle()
		state.PATROL:
			handle_patrol()
		state.CHASE:
			handle_chase()
		state.START:
			handle_start()
	
	move_and_collide(velocity * delta)

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
	direction = collision_shape_2d.global_position.direction_to(player_target.global_position)
	
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

func handle_start() -> void:
	direction = collision_shape_2d.global_position.direction_to(start_position)
	velocity = direction * patrol_speed
	animated_sprite_2d.play("walk_side")
	if collision_shape_2d.global_position.distance_to(start_position) < 1:
		current_state = state.IDLE

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

func return_to_start() -> void:
	current_state = state.START
