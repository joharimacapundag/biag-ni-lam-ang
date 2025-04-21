extends PanelContainer
class_name BattleMultiplierActionsContainer

@export var ui_battle_multiplier: UIBattleMultiplier
@export var button_group: ButtonGroup = preload("res://scripts/resources/buttons/action_button_group.tres")
var action_scene: PackedScene = preload("uid://dv4g3ekevo46h")
	
signal actions_sended(actions: Array)
signal action_sended(action)
signal actions_cleared
signal actions_unselected

func _ready() -> void:
	if ui_battle_multiplier:
		ui_battle_multiplier.actions_changed.connect(_on_actions_changed)
		ui_battle_multiplier.ilocano_word_changed.connect(_on_word_label_text_changed)
		ui_battle_multiplier.time_text_changed.connect(_on_time_label_text_changed)
		ui_battle_multiplier.questionaire_text_changed.connect(_on_questionaire_label_text_changed)
		
func _on_word_label_text_changed(text: String)-> void:
	%IlocanoWordLabel.text = text

func _on_time_label_text_changed(text: String)->void:
	%TimeLabel.text = text

func _on_questionaire_label_text_changed(text: String)-> void:
	%QuestionaireLabel.text = text

func send_actions(actions: Array)-> void:
	actions_sended.emit(actions)

func send_action(action)-> void:
	action_sended.emit(action)

func clear_actions()-> void:
	for child in %ChoicesContainer.get_children():
		child.queue_free()
	actions_cleared.emit()

func unselect_actions()-> void:
	for button in button_group.get_buttons():
		button.set_pressed_no_signal(false)
	actions_unselected.emit()

func _on_actions_changed(actions: Array)-> void:
	clear_actions()
	for action in actions:
		var action_node = action_scene.instantiate()
		action_node.action = action
		action_node.button_group = button_group
		action_node.pressed.connect(func() -> void: 
			send_action(action)
			send_actions(actions)
		)
		%ChoicesContainer.add_child(action_node)
