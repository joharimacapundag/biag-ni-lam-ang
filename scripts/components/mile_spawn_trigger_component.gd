extends Node
class_name MileSpawnTriggerComponent

var traveler: Traveler

func _ready() -> void:
	GameEvents.mile_added.connect(_on_mile_added)
	traveler = get_parent().lead_traveler

func _on_mile_added(miles: int)->void:
	GameSpawner.mile_spawn(miles, GameStatus.current_act, get_parent(), traveler.position + Vector2(get_viewport().size.x, 0))
	#for child in get_window().get_node("/root/GameEventSpawner").get_children():
		#if child is Traveler:
			#if child.traveler_resource.id == lead_id:
				#
