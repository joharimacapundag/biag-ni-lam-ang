extends Node
class_name TravelerStopComponent

@export var traveler: Traveler
@export var area_2d: Area2D

var is_in_battle: bool 

func _ready() -> void:
	if area_2d:
		area_2d.area_entered.connect(_on_area_entered)
	
func _on_area_entered(area_2d: Area2D)->void:
	if area_2d.get_parent().is_in_group("npc") && area_2d.get_parent().is_in_group("enemy"):
		GameTime.pause()
