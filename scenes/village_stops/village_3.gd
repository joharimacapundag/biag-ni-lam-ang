extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		Dialogic.start("act_2_fathers challenge")
		GameTime.pause()
		await Dialogic.timeline_ended
		GameSceneManager.push_scene("uid://comg2om2c2be0")
		await get_tree().create_timer(2).timeout
		GameSceneManager.pop_scene()
		GameStatus.current_act = "act_3"
		GameTime.unpause()
