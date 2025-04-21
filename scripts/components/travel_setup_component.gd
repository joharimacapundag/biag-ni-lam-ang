extends Node
class_name TravelSetupComponent

@export var travel_mode: TravelMode

func _ready() -> void:
	GameEvents.travel_started.connect(_on_travel_started)
	GameEvents.travel_stopped.connect(_on_travel_stopped)

func _on_travel_started()->void:
	for traveler in travel_mode.travelers:
		traveler.start_travel()

func _on_travel_stopped()->void:
	for traveler in travel_mode.travelers:
		traveler.stop()
