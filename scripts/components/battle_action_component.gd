extends Node
class_name BattleActionComponent

@export var battle_mode: BattleMode
@export var ui_battle_multiplier: UIBattleMultiplier
#@export var in_game_traveler: Traveler

var is_correct: bool
func _ready() -> void:
	GameEvents.action_executed.connect(_on_action_executed)
	if ui_battle_multiplier:
		ui_battle_multiplier.corrected.connect(_on_corrected)
		ui_battle_multiplier.uncorrected.connect(_on_uncorrected)
		
func _on_action_executed(traveler: Traveler, action: Dictionary, targets: Array)-> void:
	if traveler.is_in_group("player") && !traveler.is_died:
		await GameEvents.selecting_action_finished
		
		if action["action_type"] == "combat_action":
			if is_correct:
				traveler.attack(targets)
			else:
				traveler.attack([traveler])
		elif action.get("action_type") == "support_action" :
			traveler.heal()
		elif action.get("action_type") == "item_action":
			traveler.heal()
			
		await traveler.action_finished
		if is_correct:
			traveler.use_action(action["name"], targets)
		
			for target in targets:
				if target is Traveler:
					if target.is_died:
						battle_mode.traveler_defeat(target)
			
			battle_mode.end_turn()
		else:
			traveler.use_action(action["name"], [traveler])
			
			for target in [traveler]:
				if target is Traveler:
					if target.is_died:
						battle_mode.traveler_defeat(target)
			
			battle_mode.end_turn()

func _on_corrected(action)->void:
	is_correct = true
	
func _on_uncorrected(action)->void:
	is_correct = false
