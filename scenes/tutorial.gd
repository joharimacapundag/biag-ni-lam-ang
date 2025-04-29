extends Node2D

func _ready() -> void:
	GameTime.pause()
	Dialogic.start("tutorial")
	await Dialogic.timeline_ended
	get_tree().change_scene_to_file("uid://fjdph61htgra")
