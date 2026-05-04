extends CharacterBody2D
class_name LittleCreacher

@onready var little_creacher: LittleCreacher = $"."
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detector: Area2D = $PlayerDetector
@onready var chase_timer: Timer = $ChaseTimer
@onready var idle_timer: Timer = $IdleTimer
@onready var hitbox: HitBox = $HitBox
@onready var hurtbox: HurtBox = $HurtBox
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var wander_timer: Timer = $WanderTimer

@export var patrol_speed: float
var direction : Vector2 = Vector2.DOWN
var facing = "right"
enum state {IDLE, PATROL, CHASE, START, DIE, WANDER}
var current_state : state = state.IDLE
var player_target = Player
@onready var start_position
var health : int = 2
var can_chase : bool = true
signal health_update (int)
@export var little_creacher_instance = little_creacher
var is_dying : bool = false
var knockbackVelocity : Vector2 = Vector2.ZERO
var rng = RandomNumberGenerator.new()
@export var min_wander_points : int
@export var max_wander_points_plus_one : int
@warning_ignore("narrowing_conversion")
var random_wander_id : int
var debug_wander_id : int
var is_chase : bool = false
@export var wander_wait_time : float = 1.4

func _ready() -> void:
	player_target = get_tree().get_first_node_in_group("player")
	start_position = collision_shape_2d.global_position
	GameManager.wander_id = random_wander_id
	if can_chase == true:
		player_detector.body_entered.connect(check_for_player)
		player_detector.body_exited.connect(player_left)
	chase_timer.timeout.connect(end_chase)
	idle_timer.timeout.connect(return_to_wander)
	hurtbox.send_damage.connect(take_damage)
	wander_timer.timeout.connect(start_wander)
	await get_tree().create_timer(0.1).timeout
	GameManager.wander_id_sent.emit()

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
		state.WANDER:
			handle_wander()
	
	if knockbackVelocity != Vector2.ZERO:
		velocity = knockbackVelocity
	
	move_and_collide(velocity * delta)

func handle_idle() -> void:
	if facing == "right":
		animated_sprite_2d.play("idle_side")
		animated_sprite_2d.flip_h = false
	elif facing == "left":
		animated_sprite_2d.play("idle_side")
		animated_sprite_2d.flip_h = true
	velocity=Vector2.ZERO
	await get_tree().create_timer(0.01).timeout
	start_wander()
	await get_tree().create_timer(wander_wait_time).timeout
	if is_chase == false:
		current_state = state.WANDER

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
	
	is_chase = true
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
	if direction.x < 0:
		facing = "left"
	elif direction.x > 0:
		facing = "right"
	velocity = direction * patrol_speed
	
	animated_sprite_2d.play("walk_side")
	if facing == "right":
		animated_sprite_2d.flip_h = false
	elif facing == "left":
		animated_sprite_2d.flip_h = true
	if collision_shape_2d.global_position.distance_to(start_position) < 1:
		current_state = state.IDLE

func handle_die() -> void:
	can_chase = false
	is_dying = true
	chase_timer.stop()
	idle_timer.stop()
	velocity = Vector2.ZERO
	animated_sprite_2d.play("die")
	animation_player_2.play("die")

func take_damage(damage: int) -> void:
	health -= damage
	health_update.emit(health)
	animation_player.play("hit")
	hit_sound.play()
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
	is_chase = false
	idle_timer.start()

func return_to_wander() -> void:
	current_state = state.WANDER

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

func start_wander():
	@warning_ignore("narrowing_conversion")
	random_wander_id = rng.randf_range(min_wander_points, max_wander_points_plus_one)
	while random_wander_id == debug_wander_id:
		random_wander_id = rng.randf_range(min_wander_points, max_wander_points_plus_one)
	GameManager.wander_id = random_wander_id
	GameManager.wander_id_sent.emit()

func handle_wander():
	if GameManager.wander_enemy_type == "Little Creacher":
		direction = collision_shape_2d.global_position.direction_to(GameManager.wander_marker_position)
		if direction.x < 0:
			facing = "left"
		elif direction.x > 0:
			facing = "right"
		
		if facing == "right":
			animated_sprite_2d.play("walk_side")
			animated_sprite_2d.flip_h = false
		elif facing == "left":
			animated_sprite_2d.play("walk_side")
			animated_sprite_2d.flip_h = true
		velocity = direction * patrol_speed
		
		debug_wander_id = random_wander_id
		
		if collision_shape_2d.global_position.distance_to(GameManager.wander_marker_position) < 1:
			current_state = state.IDLE

func _on_animated_sprite_2d_animation_finished() -> void:
	pass

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is HurtBox:
		knockback()

func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	if is_dying == true:
		little_creacher.queue_free()
