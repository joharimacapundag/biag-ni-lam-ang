extends Node
class_name BattleSetupComponent

@onready var inventory: Inventory = GameStatus.current_inventory

func _ready() -> void:
	GameEvents.turn_started.connect(_on_turn_started)
		
func _on_turn_started(traveler: Traveler)-> void:
	if traveler.is_in_group("player") && !traveler.is_died:
		var actual_actions: Dictionary = {}
		actual_actions.merge(GameStatus.actions_data)
		actual_actions.merge(GameStatus.items_data)
		
		var actions = traveler.traveler_resource.actions
		var inventory_items: Array[InventoryItem]
		
		if inventory:
			inventory_items = inventory.get_items()
			
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
					
		for item in inventory_items:
			var item_id = item.get_prototype().get_id()
			if actual_actions.has(item_id):
				results.append( {
					"name": item.get_property("name"), 
					"ilocano_word": actual_actions.get(item_id, "none")["ilocano_word"],
					"display_name": actual_actions.get(item_id, "none")["name"], 
					"action_type": actual_actions.get(item_id, "none")["action_type"] 
					})
					
		combat_actions = results.filter(func(element): return element["action_type"] == "combat_action")
		support_actions = results.filter(func(element): return element["action_type"] == "support_action")
		item_actions = results.filter(func(element): return element["action_type"] == "item_action")
		
		if combat_actions:
			GameEvents.battle_combat_action_changed.emit(combat_actions.pick_random())
		if support_actions:
			GameEvents.battle_support_action_changed.emit(support_actions.pick_random())
		if item_actions:
			GameEvents.battle_item_action_changed.emit(item_actions.pick_random())
