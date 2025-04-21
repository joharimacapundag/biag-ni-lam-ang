extends Node
class_name OvertimeHungerTravel
@export_range(0, 24) var overtime_game_time_hours: int = 2
@export_range(0, 100) var interval_damage = 1
@export var max_hunger: int = 100

var current_key: String
var last_damage_game_time_hours: float = 0.0

func _ready() -> void:
	GameTime.game_time_starting.connect(_on_game_time_starting)
	current_key = "hunger"

func _on_game_time_starting(hours: float)->void:
	apply(interval_damage, hours)
		
func apply(value: int, hours: float)->void:
	var game_time_hours = hours
	var elapsed_game_time_hours = game_time_hours -  last_damage_game_time_hours
	var damage_interval_hours = overtime_game_time_hours
	
	if elapsed_game_time_hours >= damage_interval_hours:
		GameStatus.current_hunger = clamp(value, 0, max_hunger)
		last_damage_game_time_hours = game_time_hours
