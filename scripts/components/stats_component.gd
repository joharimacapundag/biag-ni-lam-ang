extends Node
class_name StatsComponent

@export var traveler: Traveler
signal stats_updated(dictionary: Dictionary)
signal health_depleted

var _stats: Dictionary = {}
var last_damage_time: float = 0.0

func _ready() -> void:
	GameEvents.rested.connect(_on_rested)
	if traveler:
		var new_stats = traveler.traveler_resource.create_dictionary(GameStatus.travelers_data)
		var id = traveler.traveler_resource.id
		
		if id in GameStatus.travelers:
			id = traveler.traveler_resource.id
			_stats = GameStatus.travelers.get(id, "")
			
		else:
			_stats = _create_dictionary(new_stats)
			GameStatus.travelers.get_or_add(id, _stats)
			
		#if _stats["health"] <= 0:
			#health_depleted.emit()
			
		stats_updated.emit(_stats)
		
func _on_rested()->void:
	if traveler:
		var new_stats = traveler.traveler_resource.create_dictionary(GameStatus.travelers_data)
		var id = traveler.traveler_resource.id
		_stats = _create_dictionary(new_stats)
		
func _create_dictionary(_stats: Dictionary) -> Dictionary:
	var new_stats = {
		"health": _stats.get("max_health"),
		"stamina": _stats.get("max_stamina"),
		"strength": _stats.get("max_strength"),
		"defense": _stats.get("max_defense"),
		"speed": _stats.get("max_speed"),
	}
	new_stats.merge(_stats, true)
	
	return new_stats

func set_stats(stats: Dictionary)-> void:
	_stats = stats

func add(key: String, amount: int) -> void:
	if key in _stats:
		_stats[key] += amount
		var max_key = "max_" + key
		if max_key in _stats:
			_stats[key] = clamp(_stats[key], 0, _stats[max_key])
			
		GameStatus.travelers[traveler.traveler_resource.id] = _stats
		stats_updated.emit(_stats)
		
		if key == "health" && _stats[key] <= 0:
			health_depleted.emit()
		
func multiply(key: String, factor: float) -> void:
	if key in _stats:
		_stats[key] = int(_stats[key] * factor)
		var max_key = "max_" + key
		
		if max_key in _stats:
			_stats[key] = clamp(_stats[key], 0, _stats[max_key])
		
		GameStatus.travelers[traveler.traveler_resource.id] = _stats
		stats_updated.emit(_stats)
			
		if key == "health" && _stats[key] <= 0:
			health_depleted.emit()

func get_stat(key: String) -> int:
	return _stats.get(key, 0)
