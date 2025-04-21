extends MarginContainer

func _ready() -> void:
	pass
	
func add_enemies(enemies: Array)->void:
	for enemy in enemies:
		var ui_enemy_status: UIEnemyStatus = preload("uid://bkivojtnm4x3n").instantiate()
		if enemy is Traveler:
			ui_enemy_status.update_enemy(enemy)
			%GridContainer.add_child(ui_enemy_status)
	#
	
