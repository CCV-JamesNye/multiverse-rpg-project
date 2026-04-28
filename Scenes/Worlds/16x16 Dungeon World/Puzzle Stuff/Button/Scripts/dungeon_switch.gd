extends Node2D
class_name DungeonSwitch

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var button_id : int
enum state {UNPRESSED, PRESSED}
var current_state : state = state.UNPRESSED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	match current_state:
		state.UNPRESSED:
			unpessed()
		state.PRESSED:
			pressed()

func unpessed():
	animated_sprite_2d.play("unpressed")

func pressed():
	animated_sprite_2d.play("pressed")
	animation_player.play("pressed")
	GameManager.button_id = button_id
	GameManager.any_button_pressed.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(_body: Node2D) -> void:
	current_state = state.PRESSED
