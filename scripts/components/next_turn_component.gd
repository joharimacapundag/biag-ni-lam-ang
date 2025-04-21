extends Node
class_name NextTurnComponent

@export var battle_mode: BattleMode

func _ready() -> void:
	if battle_mode:
		battle_mode.next_turn.connect(_on_next_turn)

func _on_next_turn()-> void:
	pass
