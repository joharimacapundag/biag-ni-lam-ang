extends Node
class_name AIComponent

@export var battle_mode: BattleMode

func _ready() -> void:
	battle_mode.turn_started.connect(_on_turn_started)

func _on_turn_started(traveler: Traveler)-> void:
	if traveler.is_in_group("enemy"):
		pass
		#_random_action(traveler)
		#traveler.use_action("", [])

func _random_action(traveler: Traveler)-> void:
	var actual_actions: Dictionary = {}
	actual_actions.merge(GameStatus.actions)
	actual_actions.merge(GameStatus.items)
	
	var actions = traveler.traveler_resource.actions
	var results = []
	
	for action in actions:
		if actual_actions.has(action):
			results.append(actual_actions.get(action, {}))
	
	print(results)

func _random_targets()-> void:
	pass
