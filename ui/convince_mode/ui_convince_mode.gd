extends Control

signal data_sended

var option_button_group: ButtonGroup

func change_time_label(time)->void:
	%TimeLabel.text = time

func change_time_progress(value)->void:
	%TimeProgressBar.value = value

func change_questionaire(text)->void:
	%QuestionaireLabel.text = text

func add_options(options: Array)->void:
	for option in options:
		var new_button = DataButton.new()
		new_button.data = option
		new_button.text = option["ilocano"]
		new_button.button_group = option_button_group
		new_button.data_sended.connect(_on_data_sended)
		new_button.toggle_mode = true
		new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		%GridContainer.add_child(new_button)
		
func _on_data_sended(data)->void:
	data_sended.emit(data)
