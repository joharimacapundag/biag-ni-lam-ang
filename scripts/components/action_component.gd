extends Node 
class_name ActionComponent

signal action_applied(action: Dictionary, source: StatsComponent, targets: Array)
signal stats_modified(stats_component: StatsComponent, modifiers: Dictionary)

@export var node: Node
@export var stats_component: StatsComponent

var _actions: Dictionary = {}

func _ready() -> void:
	var new_actions: Dictionary = {}
	new_actions.merge(GameStatus.actions_data)
	new_actions.merge(GameStatus.items_data)
	_actions = new_actions
	
	if node && node.has_signal("action_used"):
		node.action_used.connect(_on_action_used)

func _on_action_used(action_name: String, targets: Array) -> void:
	if !stats_component || !_actions.has(action_name):
		print("Action or stats component not found!")
		return
	
	var action = _actions[action_name]
	var source_modifiers = action.get("modifiers", {}).get("source", {})
	var target_modifiers = action.get("modifiers", {}).get("target", {})

	_apply_modifiers_to(stats_component, source_modifiers)
	
	action_applied.emit(action, stats_component, targets)

	for target in targets:
		if target is Traveler:
			if target.has_node("StatsComponent"):
				var stats_component: StatsComponent = target.get_node("StatsComponent")
				_apply_modifiers_to(stats_component, target_modifiers)
				#print_debug(target, " Stats: ", stats_component._stats)
				
func _apply_modifiers_to(stats_comp: StatsComponent, modifiers: Dictionary) -> void:
	if "add" in modifiers:
		for stat in modifiers["add"]:
			stats_comp.add(stat, modifiers["add"][stat])
			
		#print_debug("Addition: ", stats_component._stats, " Modifiers: ", modifiers["add"])
	
	if "multiply" in modifiers:
		for stat in modifiers["multiply"]:
			stats_comp.multiply(stat, modifiers["multiply"][stat])
		#print_debug("Multiply: ", stats_component._stats, " Modifiers: ", modifiers["multiply"])

	stats_modified.emit(stats_comp, modifiers)
