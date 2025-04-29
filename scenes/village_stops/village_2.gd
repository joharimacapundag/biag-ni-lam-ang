extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		Dialogic.start("lam ang knowing about where igorot lives from igorot")
		GameTime.pause()
		await Dialogic.timeline_ended
		GameSceneManager.push_scene("uid://b7yml8r6qua42")
		await get_tree().create_timer(2).timeout
		GameSceneManager.pop_scene()
		GameStatus.current_act = "act_2"
		GameTime.unpause()
