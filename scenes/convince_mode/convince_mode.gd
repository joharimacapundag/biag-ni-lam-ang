extends Node2D

@export var button_group: ButtonGroup
@export var time_duration: int

var current_page: int = 0
var max_page: int = 0
var timer: Timer
var elapsed_time: float = 0.0

func _ready() -> void:
	GameTime.pause()
	%UiConvinceMode.option_button_group = button_group
	%UiConvinceMode.data_sended.connect(_on_data_sended)
	%Camera2D.make_current()
	
	var current_timeline = GameStatus.current_timeline
	max_page = GameStatus.convinces_data[current_timeline].keys().size()
	timer = Timer.new()
	
	load_page()
	timer.wait_time = time_duration
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	elapsed_time = 0.0  
	
	%UiConvinceMode.change_time_label(str("Time: ", time_duration))
	%UiConvinceMode.change_time_progress(100) 

func _process(delta: float) -> void:
	if timer.time_left > 0:
		var remaining_time = ceil(timer.time_left)
		var progress_value = (timer.time_left / time_duration) * 100
		%UiConvinceMode.change_time_label(str("Time: ", remaining_time))  # Update label
		%UiConvinceMode.change_time_progress(progress_value)  # Update progress bar

func load_page() -> void:
	var current_timeline = GameStatus.current_timeline
	if current_page < max_page:
		var current: Dictionary = GameStatus.convinces_data[current_timeline][str(current_page)]
		change_current_page(current["questionaire"], current["options"])
	else:
		GameEvents.convince_ended.emit()

func change_current_page(questionare, options: Array = []) -> void:
	%UiConvinceMode.change_questionaire(questionare)
	%UiConvinceMode.add_options(options)

func next_page() -> void:
	if current_page < max_page - 1:
		current_page += 1
		load_page()
	else:
		print("No more pages left!") 
		GameEvents.convince_ended.emit(true, "branch_1")

func _on_timer_timeout() -> void:
	print("Time's up!")  
	%UiConvinceMode.change_time_label("0")
	%UiConvinceMode.change_time_progress(0)
	GameEvents.convince_ended.emit(false, "branch_1")
	print("Game Over!")

func _on_data_sended(data) -> void:
	if data["correct"]:
		%CorrectContainer.show()
		%Corrected.text = "Correct!"
		await get_tree().create_timer(2).timeout
		%CorrectContainer.hide()
		next_page()
	else:
		print("Game Over!")
		GameEvents.convince_ended.emit(false, "branch_1")
