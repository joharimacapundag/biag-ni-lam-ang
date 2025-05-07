extends Node2D
func _ready() -> void:
	GameEvents.hide_ui()
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://bsnmb0yy711yq")
