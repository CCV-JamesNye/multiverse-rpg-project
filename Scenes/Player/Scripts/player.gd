class_name Player extends CharacterBody2D

# Determines how fast the Player will move
var speed : float = 350
var facing = "none"
var health : int = 10
var max_health : int = 10
var death_anim : bool = false
signal health_update (int)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $HurtBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.send_damage.connect(take_damage)
	animated_sprite_2d.play("idle_down")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Stores current direction
	var direction : Vector2 = Vector2.ZERO
	
	# Reads input
	if Input.is_action_pressed("move_right"):
		facing = "right"
		play_anim(1)
		direction.x += 1
		direction.y = 0
	if Input.is_action_pressed("move_left"):
		facing = "left"
		play_anim(1)
		direction.x -= 1
		direction.y = 0
	if Input.is_action_pressed("move_down"):
		facing = "down"
		play_anim(1)
		direction.y += 1
		direction.x = 0
	if Input.is_action_pressed("move_up"):
		facing = "up"
		play_anim(1)
		direction.y -= 1
		direction.x = 0
	if !Input.is_anything_pressed() && death_anim == false:
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
		animated_sprite_2d.flip_h = false
		if movement == 1:
			animated_sprite_2d.play("walk_down")
		elif movement == 0:
			animated_sprite_2d.play("idle_down")

func take_damage(damage: int) -> void:
	health -= damage
	health_update.emit(health)
	if health <= 0:
		die()

func die() -> void:
	await SceneTransition.fade_to_black()
	if get_tree() != null:
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")
