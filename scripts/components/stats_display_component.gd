extends Node
class_name StatsDisplayComponent

@export var stats_component: StatsComponent
@export var label: Label

func _ready() -> void:
	if stats_component: 
		stats_component.stats_updated.connect(_on_stats_updated)

func _on_stats_updated(stats: Dictionary)->void:
	if label:
		label.text = str("Health: ", stats.get("health", ""))
