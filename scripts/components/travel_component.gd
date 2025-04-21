extends Node
class_name TravelComponent

signal speed_calculated(current, max)

@export var traveler: Traveler
@export var stats_component: StatsComponent
@export var direction: int 

func _ready() -> void:
	GameEvents.travel_started.connect(_on_travel_started)
	GameEvents.travel_stopped.connect(on_stopped)
	traveler.direction_changed.connect(on_direction_changed)

func _process(delta: float) -> void:
	if stats_component && traveler:
		var total_speed = (stats_component.get_stat("speed") / stats_component.get_stat("max_speed")) * 100
		speed_calculated.emit(stats_component.get_stat("speed"), stats_component.get_stat("max_speed"))
		traveler.position.x += total_speed * direction * delta

func on_stopped()-> void:
	direction = 0

func _on_travel_started()->void:
	direction = 1

func on_direction_changed(value: int)-> void:
	direction = value
