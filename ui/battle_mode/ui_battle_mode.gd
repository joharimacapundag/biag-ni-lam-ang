extends Control
class_name UIBattleMode

func _ready() -> void:
	GameEvents.turn_started.connect(_on_turn_started)
	GameEvents.battle_target_selected.connect(_on_battle_target_selected)
	GameEvents.selecting_action_finished.connect(_on_selecting_action_finished)
	
func add_enemies(enemies:Array)->void:
	%EnemyStatusContainer.add_enemies(enemies)

func _on_turn_started(traveler: Traveler)->void:
	%UIBattleTravelerStatus.update_traveler(traveler)
	
	if traveler.is_in_group("enemy"):
		hide_player_status()
	else:
		show_player_status()
		
func _on_battle_target_selected(target)->void:
	%UITargets.hide()
	
func hide_player_status()->void:
	%TravelerStatusContainer.hide()
func show_player_status()->void:
	%TravelerStatusContainer.show()
	
func _on_selecting_action_finished()->void:
	show_player_status()
