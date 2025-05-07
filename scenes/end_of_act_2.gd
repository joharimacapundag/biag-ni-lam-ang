extends Node2D

func _ready() -> void:
	GameStatus.current_act = "act_3"
	GameEvents.rested.emit()
	GameEvents.hide_ui()
	await get_tree().create_timer(2).timeout
	GameEvents.show_ui()
