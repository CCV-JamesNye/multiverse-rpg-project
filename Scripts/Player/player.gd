extends Node2D

# Determines how fast the Player will move
var speed : float = 350

@onready var animated_sprite_2d: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("idle_down")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Stores current direction
	var direction : Vector2 = Vector2.ZERO
	var facing : Vector2
	
	# Reads input
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		facing = Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		facing = Vector2.LEFT
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		facing = Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		facing = Vector2.UP
	if direction != Vector2.ZERO:
		if direction.y < 0:
			animated_sprite_2d.play("walk_up")
		elif direction.y > 0:
			animated_sprite_2d.play("walk_down")
		else:
			animated_sprite_2d.play("walk")
			if direction.x <0:
				animated_sprite_2d.flip_h = true
			else:
				animated_sprite_2d.flip_h = false
	else:
		if Input.is_action_just_released("move_up"):
			animated_sprite_2d.play("idle_up")
		if Input.is_action_just_released("move_down"):
			animated_sprite_2d.play("idle_down")
		if Input.is_action_just_released("move_right"):
			animated_sprite_2d.play("idle")
		if Input.is_action_just_released("move_left"):
			animated_sprite_2d.play("idle")
			animated_sprite_2d.flip_h = true
	
	position += direction.normalized() * speed * delta
	pass
