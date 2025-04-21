extends Node
class_name OvertimeDamageTravelComponent

@export var traveler: Traveler
@export var stats_component: StatsComponent

@export_range(0, 24) var overtime_game_time_hours: int = 2
@export_range(0, 100) var interval_damage = 10

@onready var id = traveler.traveler_resource.id

var last_damage_game_time_hours: float = 0.0
var current_key: String = "stamina"

func _ready() -> void:
	GameTime.game_time_starting.connect(_on_game_time_starting)
	
func _on_game_time_starting(hours: float)->void:
	
	if GameStatus.travelers[id]["stamina"] <= 0:
		current_key = "health"
		
	apply(current_key, -interval_damage, hours)

func apply(key: String, value: int, hours: float)->void:
	var game_time_hours = hours
	var elapsed_game_time_hours = game_time_hours -  last_damage_game_time_hours
	var damage_interval_hours = overtime_game_time_hours
	
	if elapsed_game_time_hours >= damage_interval_hours:
		stats_component.add(key, value)
		
		last_damage_game_time_hours = game_time_hours
