extends Node
class_name RunComponent

@export var animated_sprite_2d: AnimatedSprite2D

func _ready() -> void:
	GameEvents.travel_started.connect(_on_travel_started)
	GameEvents.travel_stopped.connect(_on_travel_stopped)

func _on_travel_stopped()-> void:
	animated_sprite_2d.sprite_frames.set_animation_loop("run", false)
	animated_sprite_2d.play("idle")
	
func  _on_travel_started()-> void:
	animated_sprite_2d.sprite_frames.set_animation_loop("run", true)
	animated_sprite_2d.play("run")
