extends Area2D
class_name HitBox

@export var damage : int = 1
var knockbackVelocity : Vector2

func get_knockback(knockbackDirection, knockbackForce):
	knockbackVelocity = knockbackDirection * knockbackForce
	await get_tree().create_timer(0.1).timeout
	knockbackVelocity = Vector2.ZERO
