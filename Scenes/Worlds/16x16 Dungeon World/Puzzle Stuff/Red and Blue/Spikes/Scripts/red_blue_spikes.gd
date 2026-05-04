extends StaticBody2D
class_name RedBlueSpikes

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum spike_color {RED, BLUE}
@export var color: spike_color
enum state {DEFAULT, OFF, ON}
var current_state : state = state.DEFAULT
var is_on : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.red_blue_button_pressed.connect(color_checker)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	match current_state:
		state.DEFAULT:
			default()
		state.OFF:
			off()
		state.ON:
			on()

func default():
	if color == spike_color.RED:
		animation_player.play("default_red")
	elif color == spike_color.BLUE:
		animation_player.play("default_blue")

func off():
	if is_on == true:
		if color == spike_color.RED:
			animation_player.play("off_red")
		elif color == spike_color.BLUE:
			animation_player.play("off_blue")
		is_on = false

func on():
	if is_on == false:
		if color == spike_color.RED:
			animation_player.play("on_red")
		elif color == spike_color.BLUE:
			animation_player.play("on_blue")
		is_on = true

func color_checker():
	if color == spike_color.RED:
		if GameManager.red_button_pressed == true && current_state != state.DEFAULT:
			current_state = state.ON
		elif GameManager.blue_button_pressed == true:
			current_state = state.OFF
	elif color == spike_color.BLUE:
		if GameManager.blue_button_pressed == true && current_state != state.DEFAULT:
			current_state = state.ON
		elif GameManager.red_button_pressed == true:
			current_state = state.OFF
