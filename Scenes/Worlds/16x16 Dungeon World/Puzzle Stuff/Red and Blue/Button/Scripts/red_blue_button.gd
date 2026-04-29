extends Node2D
class_name RedBlueButton

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum button_color {RED, BLUE}
@export var color : button_color
enum state {UNPRESSED, PRESSED}
var current_state : state = state.UNPRESSED
var is_pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if not GameManager.red_blue_button_pressed.is_connected(color_checker):
		GameManager.red_blue_pressed_2.connect(color_checker)
	else:
		pass

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

func color_checker():
	if color == button_color.RED:
		if GameManager.red_button_pressed == true:
			animation_player.play("red_pressed")
			is_pressed = false
		elif GameManager.blue_button_pressed == true:
			animation_player.play("red_unpressed")
	elif color == button_color.BLUE:
		if GameManager.blue_button_pressed == true:
			animation_player.play("blue_pressed")
			is_pressed = false
		elif GameManager.red_button_pressed == true:
			animation_player.play("blue_unpressed")

func emit_the_signal():
	if not GameManager.red_blue_button_pressed.is_connected(color_checker):
		GameManager.red_blue_button_pressed.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_pressed == false:
		emit_the_signal()
		if color == button_color.RED:
			GameManager.red_button_pressed = true
			GameManager.blue_button_pressed = false
		elif color == button_color.BLUE:
			GameManager.blue_button_pressed = true
			GameManager.red_button_pressed = false
		is_pressed = true
