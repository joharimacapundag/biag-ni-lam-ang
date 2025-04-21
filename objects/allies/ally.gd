extends Node2D
class_name Ally

@export var ally: String
@export var animated_sprited_2d: AnimatedSprite2D
@export var area_2d: Area2D

func _ready() -> void:
	GameEvents.convince_ended.connect(_on_convince_ended)
	area_2d.area_entered.connect(_on_area_entered)

func _on_area_entered(area_2d: Area2D)->void:
	var node = area_2d.get_parent()
	if node.is_in_group("player") && node is Traveler:
		Dialogic.start("act_1_scene_2_a")
		GameTime.pause()
		await Dialogic.timeline_ended
		GameEvents.convince_entered.emit()
		GameSceneManager.push_scene("uid://behgyit0fnkxq")
		
func _on_convince_ended(success, branch)->void:
	if success:
		Dialogic.start("rooster_thanks")
		await Dialogic.timeline_ended
		GameEvents.ally_joined.emit("rooster")
		queue_free()
