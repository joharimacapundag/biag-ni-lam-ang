extends Node
class_name DieComponent

@export var traveler: Traveler
@export var animated_sprite_2d: AnimatedSprite2D

func _ready() -> void:
	if traveler:
		traveler.died.connect(_on_died)

func _on_died()->void:
	animated_sprite_2d.play("die")
	
	
