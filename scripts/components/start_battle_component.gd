extends Node
class_name StartBattleComponent

@export var area_2d: Area2D
@export var enemy: Enemy
@export var animated_sprite_2d: AnimatedSprite2D

func _ready() -> void:
	if area_2d:
		area_2d.area_entered.connect(_on_area_entered)
	GameEvents.battle_ended.connect(_on_battle_ended)

func _on_area_entered(area_2d: Area2D)-> void:
	if area_2d.get_parent().is_in_group("player"):
		await get_tree().create_timer(2).timeout
		GameEvents.battle_entered.emit()
		GameSceneManager.push_scene("uid://dhbse3oxk3sqy")
		GameEvents.battle_enemy_entered.emit(enemy.level)
		queue_free()
		
func _on_battle_ended(winner)->void:
	if winner == "player":
		animated_sprite_2d.play("die")
		if enemy:
			enemy.queue_free()
		
