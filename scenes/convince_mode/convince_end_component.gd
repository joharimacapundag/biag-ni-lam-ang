extends Node

func _ready() -> void:
	GameEvents.convince_ended.connect(_on_convince_ended)

func _on_convince_ended(success, branch)->void:
	if success:
		await get_tree().create_timer(3).timeout
		GameSceneManager.pop_scene()
