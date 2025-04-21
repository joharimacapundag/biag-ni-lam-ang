extends PanelContainer
@export var button_group: ButtonGroup = preload("res://scripts/resources/buttons/target_button_group.tres")

func _ready() -> void:
	GameEvents.battle_travelers_ready.connect(_on_battle_travelers_ready)
	GameEvents.battle_action_sended.connect(_on_battle_action_sended)
	hide()
	
func clear_targets()-> void:
	for child in %GridContainer.get_children():
		child.queue_free()

func _on_battle_travelers_ready(travelers: Array)->void:
	clear_targets()
	for target in travelers:
		var target_node: DataButton = DataButton.new()
		target_node.button_group = button_group
		target_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if target is Traveler:
			target_node.text = target.traveler_resource.name
		target_node.pressed.connect(func()->void: GameEvents.battle_target_selected.emit(target))
		%GridContainer.add_child(target_node)

func _on_battle_action_sended(action)->void:
	if action:
		show()
