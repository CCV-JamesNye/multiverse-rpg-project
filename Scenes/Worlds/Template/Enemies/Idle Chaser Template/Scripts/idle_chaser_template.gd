extends CharacterBody2D
class_name IdleChaser

@onready var idle_chaser: IdleChaser = $"."
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detector: Area2D = $PlayerDetector
@onready var chase_timer: Timer = $ChaseTimer
@onready var idle_timer: Timer = $IdleTimer
@onready var hitbox: HitBox = $HitBox
@onready var hurtbox: HurtBox = $HurtBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var patrol_speed: float = 110.0
var direction : Vector2 = Vector2.DOWN
var facing = "down"
enum state {IDLE, PATROL, CHASE, START, DIE}
var current_state : state = state.IDLE
var player_target = Player
@onready var start_position
var health : int = 8
var can_chase : bool = true
signal health_update (int)
@export var idle_chaser_instance = idle_chaser
var is_dying : bool = false
var knockbackVelocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	player_target = get_tree().get_first_node_in_group("player")
	start_position = collision_shape_2d.global_position
	if can_chase == true:
		player_detector.body_entered.connect(check_for_player)
		player_detector.body_exited.connect(player_left)
	chase_timer.timeout.connect(end_chase)
	idle_timer.timeout.connect(return_to_start)
	hurtbox.send_damage.connect(take_damage)

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
		state.DIE:
			handle_die()
	
	if knockbackVelocity != Vector2.ZERO:
		velocity = knockbackVelocity
	
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
	if direction.x < 0:
		facing = "left"
	elif direction.x > 0:
		facing = "right"
	
	idle_timer.stop()
	if facing == "down":
		animated_sprite_2d.play("run_down")
		animated_sprite_2d.flip_h = false
	elif facing == "up":
		animated_sprite_2d.play("run_up")
		animated_sprite_2d.flip_h = false
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

func handle_die() -> void:
	can_chase = false
	is_dying = true
	chase_timer.stop()
	idle_timer.stop()
	velocity = Vector2.ZERO
	animated_sprite_2d.play("die")

func take_damage(damage: int) -> void:
	health -= damage
	health_update.emit(health)
	animation_player.play("hit")
	handle_knockback()
	if health <= 0:
		current_state = state.DIE

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

func knockback():
	can_chase = false
	chase_timer.stop()
	velocity = Vector2.RIGHT
	await get_tree().create_timer(0.1).timeout
	can_chase = true

func handle_knockback() -> void:
	knockbackVelocity = -350 * direction
	await get_tree().create_timer(0.2).timeout
	knockbackVelocity = Vector2.ZERO
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if is_dying == true:
		idle_chaser.queue_free()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is HurtBox:
		knockback()
