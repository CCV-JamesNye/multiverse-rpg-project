extends Node2D
class_name RedBlueButton

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

enum button_color {RED, BLUE}
@export var color : button_color
enum state {UNPRESSED, PRESSED}
var current_state : state = state.UNPRESSED
var is_pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.red_blue_button_pressed.connect(color_checker)

func _physics_process(_delta: float) -> void:
	match current_state:
		state.UNPRESSED:
			unpressed()
		state.PRESSED:
			pressed()

func unpressed():
	if color == button_color.RED:
		animation_player.play("red_unpressed")
	elif color == button_color.BLUE:
		animation_player.play("blue_unpressed")

func pressed():
	if color == button_color.RED:
		animation_player.play("red_pressed")
	elif color == button_color.BLUE:
		animation_player.play("blue_pressed")

func color_checker():
	if color == button_color.RED:
		if GameManager.red_button_pressed == true:
			current_state = state.PRESSED
		elif GameManager.blue_button_pressed == true:
			current_state = state.UNPRESSED
			is_pressed = false
	elif color == button_color.BLUE:
		if GameManager.blue_button_pressed == true:
			current_state = state.PRESSED
		elif GameManager.red_button_pressed == true:
			current_state = state.UNPRESSED
			is_pressed = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player || LittleCreacher:
		if color == button_color.RED:
			GameManager.red_button_pressed = true
			GameManager.blue_button_pressed = false
		elif color == button_color.BLUE:
			GameManager.blue_button_pressed = true
			GameManager.red_button_pressed = false
		GameManager.red_blue_button_pressed.emit()
		is_pressed = true
