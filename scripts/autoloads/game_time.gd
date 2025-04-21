extends Node

signal game_time_reset
signal game_time_paused
signal game_time_unpaused
signal game_time_starting(total_game_time_hours: float)

const REAL_TIME_MINUTES: float = 2
#const REAL_TIME_MINUTES: float = 0.5
const REAL_TIME_SECONDS = REAL_TIME_MINUTES * 60
const GAME_TIME_HOURS = 24
const REAL_TIME_TO_GAME_TIME: float = REAL_TIME_SECONDS / GAME_TIME_HOURS

var elapsed_real_time_seconds:float = 0.0
var unresetable_elapsed_real_time_seconds:float = 0.0
var total_game_time_hours:float = 0.0
var current_game_time_hours:float = 0.0

var total_days: int = 0

var is_paused: bool = true

var hours = func() -> int:
	return int(current_game_time_hours)
	
var minutes = func() -> int:
	return int((current_game_time_hours - hours.call()) * 60)

var total_hours = func() -> int:
	return int(total_game_time_hours)

var total_minutes = func() -> int:
	return int(total_game_time_hours * 60)

func _process(delta: float) -> void:
	if !is_paused:
		elapsed_real_time_seconds += delta
		unresetable_elapsed_real_time_seconds += delta 
		total_game_time_hours = (unresetable_elapsed_real_time_seconds/REAL_TIME_SECONDS) * GAME_TIME_HOURS
		current_game_time_hours = (elapsed_real_time_seconds/REAL_TIME_SECONDS) * GAME_TIME_HOURS
		game_time_starting.emit(total_game_time_hours)
		
	if current_game_time_hours	>= GAME_TIME_HOURS:
		reset()
		
	#display_game_time()
		
	
func display_game_time() -> void:
	print("In-game time: %02d:%02d" % [hours.call(), minutes.call()])
	
func pause() -> void:
	is_paused = true
	game_time_paused.emit()
	
func unpause() -> void:
	is_paused = false
	game_time_unpaused.emit()
	
func reset() -> void:
	elapsed_real_time_seconds = 0.0
	current_game_time_hours = 0.0
	total_days += 1
	game_time_reset.emit()
