extends Node

@export var traveler: Traveler

func _ready() -> void:
	if traveler:
		traveler.died.connect(_on_died)

func _on_died()->void:
	GameStatus.travelers.erase(traveler.traveler_resource.id)
	
