extends Node
class_name HealComponent

@export var traveler: Traveler
@export var animated_sprited_2d: AnimatedSprite2D

func _ready() -> void:
	if traveler:
		traveler.healed.connect(_on_healed)

func _on_healed()-> void:
	var original_modulate = traveler.modulate
	traveler.modulate = Color(0, 0, 70)
	await  get_tree().create_timer(0.2).timeout
	traveler.modulate = original_modulate
	traveler.action_finished.emit()
