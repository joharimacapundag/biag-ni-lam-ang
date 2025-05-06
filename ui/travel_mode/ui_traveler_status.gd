extends PanelContainer
class_name UITravelerStatus

var current_traveler: Traveler
var danger_bars: Array[ProgressBar] = []

func _ready() -> void:
	GameTime.game_time_starting.connect(_on_game_time_starting)
	%BlinkTimer.timeout.connect(_on_blink_timer_timeout)

func update_traveler(traveler: Traveler) -> void:
	if traveler.traveler_resource.profile:
		%Profile.texture = traveler.traveler_resource.profile
	%NameLbl.text = traveler.traveler_resource.name
	if traveler.has_node("StatsComponent"):
		var stats_comp: StatsComponent = traveler.get_node("StatsComponent")
		_update_stat_bar(%HealthBar, stats_comp.get_stat("health"), stats_comp.get_stat("max_health"))
		_update_stat_bar(%StaminaBar, stats_comp.get_stat("stamina"), stats_comp.get_stat("max_stamina"))
		_update_stat_bar(%StrengthBar, stats_comp.get_stat("strength"), stats_comp.get_stat("max_strength"))
	current_traveler = traveler

func _on_game_time_starting(hours: float) -> void:
	if current_traveler:
		var traveler: Dictionary = GameStatus.travelers[current_traveler.traveler_resource.id]
		_update_stat_bar(%HealthBar, traveler["health"], traveler["max_health"])
		_update_stat_bar(%StaminaBar, traveler["stamina"], traveler["max_stamina"])
		_update_stat_bar(%StrengthBar, traveler["strength"], traveler["max_strength"])

func _update_stat_bar(bar: ProgressBar, value: float, max_value: float) -> void:
	var percent := (value / max_value) * 100
	bar.value = percent

	if percent <= 20:
		if not danger_bars.has(bar):
			danger_bars.append(bar)
		bar.modulate = Color(1, 0, 0) # Red
		%BlinkTimer.start()
	elif percent <= 40:
		bar.modulate = Color(1, 0.5, 0) # Orange
		danger_bars.erase(bar)
	else:
		bar.modulate = Color(1, 1, 1) # White
		danger_bars.erase(bar)

	if danger_bars.is_empty():
		%BlinkTimer.stop()

func _on_blink_timer_timeout() -> void:
	for bar in danger_bars:
		# Toggle between red and transparent (or any blink color)
		if bar.modulate.a == 1:
			bar.modulate.a = 0.3
		else:
			bar.modulate.a = 1
