extends Node
class_name OvertimeComponent
@export var travel_mode: TravelMode

@export_range(0, 24) var overtime_game_time_hours: int = 2
@export_range(0, 100) var interval_damage = 10

func _ready() -> void:
	if travel_mode:
		travel_mode.reduced.connect(_on_reduced)
	pass

#func reduce(stats_component: StatsComponent, key: String, value:int, hours: float)->void:
	#var game_time_hours = hours
	#var elapsed_game_time_hours = game_time_hours - stats_component.last_damage_time
	#var damage_interval_hours = overtime_game_time_hours
	#
	#if elapsed_game_time_hours >= damage_interval_hours:
		#stats_component.add(key, -value)
		#stats_component.last_damage_time = game_time_hours
	

func reduce(traveler: Traveler, stats: Dictionary, key: String, value: int, hours: float)->void:
	var game_time_hours = hours
	var elapsed_game_time_hours = game_time_hours - stats.get("last_damage_time", 0)
	var damage_interval_hours = overtime_game_time_hours
	
	if elapsed_game_time_hours >= damage_interval_hours:
		stats[key] = stats[key] - value
		
		if stats["health"] <= 0:
			traveler.die()
		
		stats["last_damage_time"] = game_time_hours
	
func _on_reduced(traveler: Traveler, hours: float)->void:
	#if traveler.has_node("StatsComponent"):
		#var stats_comp: StatsComponent = traveler.get_node("StatsComponent")
		#var current_key = "stamina"
		#
		#if stats_comp.get_stat("stamina") <= 0:
			#current_key = "health"
		#
		#reduce(stats_comp, current_key, interval_damage, hours)
	
	
		#GameStatus.update_stats(traveler.traveler_resource.id, stats_comp._stats)
	var traveler_id: String = traveler.traveler_resource.id
	if GameStatus.travelers.has(traveler_id):
		var stats = GameStatus.travelers[traveler_id]
		var current_key = "stamina"
		
		if stats.get("stamina", "") <= 0:
			current_key = "health"
			
		reduce(traveler, stats, current_key, interval_damage, hours)
		GameStatus.update_stats(traveler_id, stats)
		
