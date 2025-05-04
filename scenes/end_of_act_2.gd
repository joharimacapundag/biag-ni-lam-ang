extends Node2D

func _ready() -> void:
	GameStatus.current_act = "act_3"
	GameEvents.rested.emit()
