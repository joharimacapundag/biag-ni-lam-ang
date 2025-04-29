extends Node2D

@export var ally: String
@export var animated_sprited_2d: AnimatedSprite2D
@export var area_2d: Area2D

func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)

func _on_area_entered(area_2d: Area2D)->void:
	var node = area_2d.get_parent()
	if node.is_in_group("player") && node is Traveler:
		Dialogic.start("ally_doggie")
		GameTime.pause()
		await Dialogic.timeline_ended
		GameEvents.ally_joined.emit("doggie")
		queue_free()
		
