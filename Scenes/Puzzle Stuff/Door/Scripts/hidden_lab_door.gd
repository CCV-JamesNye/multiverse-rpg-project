extends Node2D
class_name HiddenLabDoor

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const hidden_lab_button = preload("res://Scenes/Puzzle Stuff/Button/HiddenLabButton.tscn")

@export var door_id : int
enum state {CLOSED, OPEN}
var current_state : state = state.CLOSED
var is_opened : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.any_button_pressed.connect(open_signal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	match current_state:
		state.CLOSED:
			closed()
		state.OPEN:
			open()

func closed():
	animation_player.play("closed")

func open():
	if is_opened == false:
		animation_player.play("open")
		is_opened = true

func open_signal():
	if GameManager.button_id == door_id:
		current_state = state.OPEN
