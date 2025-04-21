extends Node
class_name HealthComponent

@export var traveler: Traveler
@export var stats_component: StatsComponent

func _ready() -> void:
	if stats_component:
		stats_component.health_depleted.connect(_on_health_depleted)
		
func _on_health_depleted()-> void:
	traveler.die()
