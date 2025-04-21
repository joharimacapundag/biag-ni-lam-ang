extends PanelContainer
class_name UIEnemyStatus
var current_traveler: Traveler
func update_enemy(enemy: Traveler)->void:
	%NameLbl.text = enemy.traveler_resource.name
	if enemy.has_node("StatsComponent"):
		var stats_comp: StatsComponent = enemy.get_node("StatsComponent")
		%HealthBar.value = float(stats_comp.get_stat("health")) / float(stats_comp.get_stat("max_health"))  * 100
	current_traveler = enemy
	
func _process(delta: float) -> void:
	if current_traveler && GameStatus.travelers.has(current_traveler.traveler_resource.id):
		var traveler: Dictionary = GameStatus.travelers[current_traveler.traveler_resource.id]
		%HealthBar.value = float(traveler["health"])/ float(traveler["max_health"]) * 100
