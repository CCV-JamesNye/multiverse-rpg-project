class_name Player extends CharacterBody2D

# Determines how fast the Player will move
var speed : float = 350
var facing = "down"
var health : int = 10
var max_health : int = 10
var death_anim : bool = false
signal health_update (int)
var is_attacking : bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $HurtBox
@onready var attack_timer: Timer = $AttackTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.send_damage.connect(take_damage)
	animated_sprite_2d.play("idle_down")
	attack_timer.timeout.connect(finish_attack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Stores current direction
	var direction : Vector2 = Vector2.ZERO
	
	# Reads input
	if Input.is_action_pressed("move_right") && is_attacking == false:
		facing = "right"
		play_anim(1)
		direction.x += 1
		direction.y = 0
	if Input.is_action_pressed("move_left") && is_attacking == false:
		facing = "left"
		play_anim(1)
		direction.x -= 1
		direction.y = 0
	if Input.is_action_pressed("move_down")&& is_attacking == false :
		facing = "down"
		play_anim(1)
		direction.y += 1
		direction.x = 0
	if Input.is_action_pressed("move_up") && is_attacking == false:
		facing = "up"
		play_anim(1)
		direction.y -= 1
		direction.x = 0
	if Input.is_action_pressed("attack") && is_attacking == false:
		attack()
		direction.y = 0
		direction.x = 0
	if !Input.is_anything_pressed() && death_anim == false && is_attacking == false:
		play_anim(0)
		direction.x = 0
		direction.y = 0
	
	position += direction.normalized() * speed * delta
	move_and_collide(velocity * delta)
	pass

func play_anim(movement):
	if facing == "right":
		animated_sprite_2d.flip_h = false
		if movement == 2:
			animated_sprite_2d.play("sword_side")
		elif movement == 1:
			animated_sprite_2d.play("walk_side")
		elif movement == 0:
			animated_sprite_2d.play("idle_side")
	if facing == "left":
		animated_sprite_2d.flip_h = true
		if movement == 2:
			animated_sprite_2d.play("sword_side")
		elif movement == 1:
			animated_sprite_2d.play("walk_side")
		elif movement == 0:
			animated_sprite_2d.play("idle_side")
	if facing == "up":
		animated_sprite_2d.flip_h = false
		if movement == 2:
			animated_sprite_2d.play("sword_up")
		elif movement == 1:
			animated_sprite_2d.play("walk_up")
		elif movement == 0:
			animated_sprite_2d.play("idle_up")
	if facing == "down":
		animated_sprite_2d.flip_h = false
		if movement == 2:
			animated_sprite_2d.play("sword_down")
		elif movement == 1:
			animated_sprite_2d.play("walk_down")
		elif movement == 0:
			animated_sprite_2d.play("idle_down")

func take_damage(damage: int) -> void:
	health -= damage
	health_update.emit(health)
	if health <= 0:
		die()

func die() -> void:
	GameManager.plr_die()

func finish_attack() -> void:
	is_attacking = false

func attack():
	play_anim(2)
	is_attacking = true
	attack_timer.start()
