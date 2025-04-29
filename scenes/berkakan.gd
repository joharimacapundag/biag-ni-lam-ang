extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		Dialogic.start("act_3_scene_1")
		GameTime.pause()
		await Dialogic.timeline_ended
		Dialogic.start("act_3_scene_2_inside_berrakan")
		await Dialogic.timeline_ended
		GameTime.unpause()
