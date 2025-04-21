extends MarginContainer
class_name UIBattleTravelerStatus

func update_traveler(traveler: Traveler)->void:
	%NameLbl.text = traveler.traveler_resource.name
	if traveler.has_node("StatsComponent"):
		var stats_comp: StatsComponent = traveler.get_node("StatsComponent")
		%HealthBar.value = float(stats_comp.get_stat("health")) / float(stats_comp.get_stat("max_health"))  * 100
		%StaminaBar.value = float(stats_comp.get_stat("stamina")) / float(stats_comp.get_stat("max_stamina"))  * 100
