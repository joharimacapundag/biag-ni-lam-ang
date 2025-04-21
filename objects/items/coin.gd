extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		GameStatus.current_gold += 1
		await get_tree().create_timer(0.25).timeout
		queue_free()
