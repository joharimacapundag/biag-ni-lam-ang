extends MarginContainer
func _ready() -> void:
	GameEvents.battle_combat_action_changed.connect(_on_battle_combat_action_changed)
	GameEvents.battle_support_action_changed.connect(_on_battle_support_action_changed)
	GameEvents.battle_item_action_changed.connect(_on_battle_item_action_changed)

func _on_battle_combat_action_changed(action: Dictionary)->void:
	%CombatAction.update_action(action)

func _on_battle_support_action_changed(action: Dictionary)->void:
	%SupportAction.update_action(action)

func _on_battle_item_action_changed(action: Dictionary)->void:
	%ItemAction.update_action(action)
