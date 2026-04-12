class_name Player extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var hurtbox: Area2D = $HurtBox
@onready var hit: AudioStreamPlayer2D = $Hit

# Determines how fast the Player will move
var speed : float = 350
var facing = "down"
var health : int = 10
var max_health : int = 10
signal health_update (int)
var is_attacking : bool = false
var is_dying : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	hurtbox.send_damage.connect(take_damage)
	animated_sprite_2d.play("idle_down")
	
	if RoomChangeHandler.activate == true:
		global_position = RoomChangeHandler.player_position
		RoomChangeHandler.activate = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Stores current direction
	var direction : Vector2 = Vector2.ZERO
	
	# Reads input
	if Input.is_action_pressed("move_right") && is_attacking == false && is_dying == false:
		facing = "right"
		play_anim(1)
		direction.x += 1
		direction.y = 0
	if Input.is_action_pressed("move_left") && is_attacking == false && is_dying == false:
		facing = "left"
		play_anim(1)
		direction.x -= 1
		direction.y = 0
	if Input.is_action_pressed("move_down")&& is_attacking == false && is_dying == false:
		facing = "down"
		play_anim(1)
		direction.y += 1
		direction.x = 0
	if Input.is_action_pressed("move_up") && is_attacking == false && is_dying == false:
		facing = "up"
		play_anim(1)
		direction.y -= 1
		direction.x = 0
	if Input.is_action_pressed("attack") && is_attacking == false && is_dying == false:
		attack()
		direction.y = 0
		direction.x = 0
	if !Input.is_anything_pressed() && is_attacking == false && is_dying == false:
		play_anim(0)
		direction.x = 0
		direction.y = 0
	
	position += direction.normalized() * speed * delta
	move_and_collide(velocity * delta)
	pass

func play_anim(movement):
	if facing == "right":
		animated_sprite_2d.flip_h = false
		if movement == 1:
			animated_sprite_2d.play("walk_side")
		elif movement == 0:
			animated_sprite_2d.play("idle_side")
	if facing == "left":
		animated_sprite_2d.flip_h = true
		if movement == 1:
			animated_sprite_2d.play("walk_side")
		elif movement == 0:
			animated_sprite_2d.play("idle_side")
	if facing == "up":
		animated_sprite_2d.flip_h = false
		if movement == 1:
			animated_sprite_2d.play("walk_up")
		elif movement == 0:
			animated_sprite_2d.play("idle_up")
	if facing == "down":
		if movement == 1:
			animated_sprite_2d.play("walk_down")
		elif movement == 0:
			animated_sprite_2d.play("idle_down")

func take_damage(damage: int) -> void:
	health -= damage
	health_update.emit(health)
	animation_player_2.play("hit")
	hit.play()
	if health <= 0:
		die()

func die() -> void:
	is_dying = true
	if facing == "left":
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("death")

func finish_attack() -> void:
	is_attacking = false

func attack():
	is_attacking = true
	if facing == "right":
		animation_player.play("sword_right")
	if facing == "left":
		animation_player.play("sword_left")
	if facing == "up":
		animation_player.play("sword_up")
	if facing == "down":
		animation_player.play("sword_down")

func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attacking == true:
		is_attacking = false
	if is_dying == true:
		GameManager.plr_die()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if is_attacking == true:
		is_attacking = false

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.has_method("get_knockback"):
		var knockbackDirection = global_position.direction_to(body.global_position)
		body.get_knockback(knockbackDirection, 30)
