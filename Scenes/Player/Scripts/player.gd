extends CharacterBody2D

# Determines how fast the Player will move
var speed : float = 350
var facing = "none"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	if !Input.is_anything_pressed():
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
