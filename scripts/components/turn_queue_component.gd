extends Node
class_name TurnQueueComponent

var active_traveler: Traveler
var turn_queue_order: Array[Traveler]

func initialize_turn_order(travelers: Array) -> Array:
	travelers.sort_custom(_sort_by_speed)
	return travelers

func _sort_by_speed(a: Traveler, b: Traveler)-> bool:
	var condition: bool
	if a.has_node("StatsComponent") && b.has_node("StatsComponent"):
		var a_stats: StatsComponent = a.get_node("StatsComponent")
		var b_stats: StatsComponent = b.get_node("StatsComponent")
		condition = a_stats.get_stat("health") > b_stats.get_stat("health")
	return condition
