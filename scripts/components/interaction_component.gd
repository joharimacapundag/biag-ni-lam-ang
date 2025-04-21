extends Node
class_name InteractionComponent

#@export var npc: NPC
@export var area_2d: Area2D

func _ready() -> void:
	if area_2d:
		area_2d.area_entered.connect(_on_area_entered)

func _on_area_entered(area_2d: Area2D)->void:
	if area_2d.get_parent().is_in_group("player") && area_2d.get_parent() is Traveler:
		var traveler: Traveler = area_2d.get_parent()
		if traveler.traveler_resource.id == "lam-ang":
			#Dialogic.start(GameStatus.current_timeline)
			#await Dialogic.timeline_ended
			#SceneManager.push_scene("res://scenes/ui/convince_mode/convince_mode.tscn")
			GameEvents.convince_entered.emit()
			#npc.queue_free()
			
