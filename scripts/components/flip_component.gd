extends Node
class_name FlipComponent

@export var sprite_2d: AnimatedSprite2D
	
func _on_flipped()->void:
	sprite_2d.flip_h = true
	
