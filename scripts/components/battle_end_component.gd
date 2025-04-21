extends Node
class_name BattleEndComponent

#@export var ui_battle_ended: UIBattleEnded

func _ready() -> void:
	GameEvents.battle_started.connect(_on_battle_started)
	GameEvents.battle_ended.connect(_on_battle_ended)
		
func _on_battle_started()->void:
	GameTime.pause()
	
func _on_battle_ended(winner: String)-> void:
	if winner == "player" :
		await get_tree().create_timer(3).timeout
		GameSceneManager.pop_scene()
		GameTime.unpause()
