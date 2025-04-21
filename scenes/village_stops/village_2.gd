extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		GameSceneManager.push_scene("uid://bxl748f8adxqh")
		GameTime.pause()
