extends OvertimeDamageTravelComponent
class_name OvertimeHungerTraveling

func _ready() -> void:
	GameTime.game_time_starting.connect(_on_game_time_starting)
	
func _on_game_time_starting(hours: float)->void:
	if GameStatus.current_hunger >= 100:
		current_key = "strength"
		
	apply(current_key, -interval_damage, hours)	
