extends Control
class_name UIBattleMultiplier

signal timer_timeout

signal actions_changed(actions: Array)

signal ilocano_word_changed(text: String)
signal time_text_changed(text: String)
signal questionaire_text_changed(text: String)

signal correct_answer_changed(action)
signal corrected(action)
signal uncorrected(action)
signal selecting_action_finished


@export var battle_mode: BattleMode
@export var time_duration: int = 4
@export var battle_multiplier_feedback: BattleMultiplierFeedbackContainer
@export var ui_battle_mode: UIBattleMode
@onready var time_left = time_duration
var timer: Timer

var correct_answer: Dictionary
var selected_actions: Array
var selected_action
var selected_ilocano_word: String

var is_correct: bool 

func _ready() -> void:
	hide()
	GameEvents.action_selected.connect(_on_action_selected)
	timer = %Timer
	%MultipleChoice.actions_sended.connect(_on_actions_sended)
	%MultipleChoice.action_sended.connect(_on_action_sended)
	%Timer.timeout.connect(_on_timer_timeout)
	
func _on_action_selected(action: Dictionary, targets: Array)->void:
	ui_battle_mode.hide_player_status()
	if battle_mode.current_traveler.is_in_group("player"):
		selected_ilocano_word = action["ilocano_word"]
		show()
		start_timer()
		change_correct_answer(action)
		change_ilocano_word(selected_ilocano_word)
		change_questionaire(str("What ", selected_ilocano_word, " means?"))
		var actions: Dictionary = {}
		actions.merge(GameStatus.actions_data)
		actions.merge(GameStatus.items_data)
		
		var results: Array
		match correct_answer["action_type"]:
			"combat_action": results = actions.values().filter(func(action): return action.get("action_type") == "combat_action" && action.get("name") != correct_answer["display_name"])
			"support_action": results = actions.values().filter(func(action): return action.get("action_type") == "support_action" && action.get("name") != correct_answer["display_name"])
			"item_action": results = actions.values().filter(func(action): return action.get("action_type") == "item_action" && action.get("name") != correct_answer["display_name"])
		print(results)
		results.shuffle()
		results.resize(2)
		
		var all = [correct_answer] + results
		all.shuffle()
		
		change_actions(all)
		

func start_timer()-> void:
	change_time_text(str("Time: ", time_left))
	timer.start(1)

func reset_timer()-> void:
	time_left = time_duration
	timer.stop()
	
func change_actions(actions: Array)-> void:
	actions_changed.emit(actions)

func change_correct_answer(action: Dictionary)->void:
	correct_answer = action
	correct_answer_changed.emit(action)

func change_time_text(text: String)-> void:
	time_text_changed.emit(text)

func change_ilocano_word(text: String)-> void:
	ilocano_word_changed.emit(text)

func change_questionaire(text: String)-> void:
	questionaire_text_changed.emit(text)

func check_action()-> void:
	if selected_action && selected_action["name"] == correct_answer["name"]:
		battle_multiplier_feedback.change_correct_label_text("Correct!")
		battle_multiplier_feedback.change_correct_label_font_color(Color.GREEN)
		battle_multiplier_feedback.change_answer_label_text(str("[center]The meaning of [color=black][font_size=20]", selected_ilocano_word.to_upper(), "[/font_size][/color] is [color=gray][font_size=20]",correct_answer["name"].to_upper(), "[/font_size][/color][/center]") )
		battle_multiplier_feedback.change_multiplier_applied_text("Multiplier Applied")
		is_correct = true
		corrected.emit(selected_action)
	else:
		battle_multiplier_feedback.change_correct_label_text("Wrong!")
		battle_multiplier_feedback.change_correct_label_font_color(Color.RED)
		battle_multiplier_feedback.change_answer_label_text(str("[center]The meaning of [color=black][font_size=20]", selected_ilocano_word.to_upper(), "[/font_size][/color] is [color=gray][font_size=20]", correct_answer["name"].to_upper(), "[/font_size][/color][/center]"))
		battle_multiplier_feedback.change_multiplier_applied_text("No Multiplier Applied")
		is_correct = false
		uncorrected.emit(selected_action)

func _on_actions_sended(actions: Array) ->void:
	selected_actions = actions

func _on_action_sended(action) -> void:
	selected_action = action
	check_action()
	time_left = 0
	hide()
	battle_multiplier_feedback.show()
	await get_tree().create_timer(1.5).timeout
	battle_multiplier_feedback.hide()
	GameEvents.selecting_action_finished.emit()
	
		
func _on_timer_timeout()-> void:
	time_left -= 1
	change_time_text(str("Time: ", time_left))
	if time_left < 0:
		timer.stop()
		hide()
		if !selected_action:
			uncorrected.emit(selected_action)
		reset_timer()
		timer_timeout.emit()
		check_action()
		battle_multiplier_feedback.show()
		
		await get_tree().create_timer(5).timeout
		battle_multiplier_feedback.hide()
		GameEvents.selecting_action_finished.emit()
