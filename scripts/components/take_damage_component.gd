extends Node
class_name TakeDamageComponent

@export var traveler: Traveler
@export var animated_sprited_2d: AnimatedSprite2D

func _ready() -> void:
	if traveler :
		traveler.damage_taken.connect(_on_damage_taken)

func _on_damage_taken()-> void:
	var original_modulate = traveler.modulate
	traveler.modulate = Color(255, 0, 0)
	await get_tree().create_timer(0.2).timeout
	traveler.modulate = original_modulate
	traveler.damage_taken_finished.emit()
