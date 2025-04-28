extends Node2D

func _ready() -> void:
	Dialogic.start("act_2_scene_1_a_bossigorot")
	await Dialogic.timeline_ended
	GameEvents.travel_started.emit()
	await get_tree().create_timer(7).timeout
	%AudioStreamPlayer2D.stop()
	get_tree().change_scene_to_file("uid://buc2v2ocwo4ci")
	
