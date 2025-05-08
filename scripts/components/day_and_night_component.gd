extends Node
class_name  DayAndNightComponent
@export var node: Node2D

var day_color: Color = Color(0.7, 0.9, 1)   
<<<<<<< HEAD
var night_color: Color = Color("#657785")
=======
var night_color: Color = Color(0.35, 0.4, 0.6)
>>>>>>> 8ed73d315825f549fd76f91ea52be7a00b377c03
var total_hours: float = 12
var day_incremented: bool

func _ready() -> void:
	GameTime.game_time_starting.connect(_on_game_time_starting)
	
func _on_game_time_starting(hours: float)->void:
	var current_hour = int(hours + 12) % 24
	var normalized_time = current_hour / 24.0
	var factor = 0.5 + 0.5 * cos((normalized_time - 0.5) * 2 * PI)
	
	if node:
		node.modulate = night_color.lerp(day_color, factor)
	
