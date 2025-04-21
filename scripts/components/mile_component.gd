extends Node
class_name MileComponent

@export_range(0, 24) var overtime_game_time_hours: float = 0.5

var last_mile_game_time_hours: float = 0.0  
var miles: int = 0

func _ready() -> void:
	GameTime.game_time_starting.connect(_on_game_time_starting)
	
func _on_game_time_starting(hours:float)->void:
	var current_game_time_hours: float = hours
	var mile_interval_hours: float = overtime_game_time_hours
	
	if current_game_time_hours - last_mile_game_time_hours >= mile_interval_hours:
		miles += 1
		GameEvents.mile_added.emit(miles)
		last_mile_game_time_hours = current_game_time_hours  
