extends Node
class_name BattleAIComponent

@export var battle_mode: BattleMode

func _ready() -> void:
	GameEvents.turn_started.connect(_on_turn_started)
	GameEvents.action_executed.connect(_on_action_executed)

func _on_turn_started(traveler: Traveler) -> void:
	if traveler.is_in_group("enemy") && !traveler.is_died:
		var actual_actions: Dictionary = {}
		actual_actions.merge(GameStatus.actions_data)
		actual_actions.merge(GameStatus.items_data)
		
		var actions = traveler.traveler_resource.actions
		var inventory_items: Array[InventoryItem]
		
		#if inventory:
			#inventory_items = inventory.get_items()
			
		var results: Array
			
		var combat_actions: Array
		var support_actions: Array
		var item_actions: Array
			
		for action in actions:
			if actual_actions.has(action):
				results.append( {
					"name": action, 
					"ilocano_word": actual_actions.get(action, "none")["ilocano_word"],
					"display_name": actual_actions.get(action, "none")["name"], 
					"action_type": actual_actions.get(action, "none")["action_type"] 
					})
		
		combat_actions = results.filter(func(element): return element["action_type"] == "combat_action")
		support_actions = results.filter(func(element): return element["action_type"] == "support_action")
		#item_actions = results.filter(func(element): return element["action_type"] == "item_action")

		var random_type_num = RandomNumberGenerator.new().randi_range(1,1)
		var selected_action
		
		match random_type_num:
			1: selected_action = combat_actions.pick_random()
			#2: selected_action = support_actions.pick_random()
		
		print("Enemy Thinking...")
		await get_tree().create_timer(2).timeout
		battle_mode.select_action(selected_action, [battle_mode.travelers.filter(func(enemy): return enemy != traveler).pick_random()])
		
	
func _on_action_executed(traveler: Traveler, action: Dictionary, targets: Array)-> void:
	if traveler.is_in_group("enemy") && !traveler.is_died:
		if action["action_type"] == "combat_action":
			traveler.attack(targets)
		elif action.get("action_type") == "support_action" :
			traveler.heal()
		elif action.get("action_type") == "item_action":
			pass
		
		await traveler.action_finished
		
		traveler.use_action(action["name"], targets)
		
		for target in targets:
			if target is Traveler:
				if target.is_died:
					battle_mode.traveler_defeat(target)
		
		battle_mode.end_turn()
