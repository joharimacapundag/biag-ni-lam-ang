extends PanelContainer
class_name UITravelerStatus

var current_traveler: Traveler

func _ready() -> void:
	GameTime.game_time_starting.connect(_on_game_time_starting)

func update_traveler(traveler: Traveler)->void:
	if traveler.traveler_resource.profile:
		%Profile.texture = traveler.traveler_resource.profile
	%NameLbl.text = traveler.traveler_resource.name
	if traveler.has_node("StatsComponent"):
		var stats_comp: StatsComponent = traveler.get_node("StatsComponent")
		%HealthBar.value = float(stats_comp.get_stat("health")) / float(stats_comp.get_stat("max_health"))  * 100
		%StaminaBar.value = float(stats_comp.get_stat("stamina")) / float(stats_comp.get_stat("max_stamina"))  * 100
		%StrengthBar.value = float(stats_comp.get_stat("strength")) / float(stats_comp.get_stat("max_strength"))  * 100
	current_traveler = traveler
	
func _on_game_time_starting(hours: float)->void:
	if current_traveler:
		var traveler: Dictionary = GameStatus.travelers[current_traveler.traveler_resource.id]
		%HealthBar.value = float(traveler["health"])/ float(traveler["max_health"]) * 100
		%StaminaBar.value = float(traveler["stamina"])/ float(traveler["max_stamina"]) * 100
		%StrengthBar.value = float(traveler["max_strength"])/ float(traveler["max_strength"]) * 100
