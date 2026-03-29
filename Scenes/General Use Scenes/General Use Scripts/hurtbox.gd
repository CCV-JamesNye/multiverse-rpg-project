extends Area2D
class_name HurtBox

signal send_damage (int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(take_damage)
	pass # Replace with function body.

func take_damage (area : Area2D) -> void:
	if area is HitBox:
		send_damage.emit(area.damage)
