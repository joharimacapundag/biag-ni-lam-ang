extends Control
func _ready() -> void:
	%MenuButton.pressed.connect(_on_menu_button_pressed)
	GameTime.game_time_starting.connect(_on_game_time_starting)
	GameEvents.ui_hidden.connect(_on_ui_hidden)
	GameEvents.ui_showed.connect(_on_ui_visible)

func add_travelers(travelers: Array)->void:
	for traveler in travelers:
		var ui_traveler_status: UITravelerStatus = preload("uid://cbbpqxpkfqq30").instantiate()
		if traveler is Traveler:
			ui_traveler_status.update_traveler(traveler)
			%GridContainer.add_child(ui_traveler_status)

func add_traveler(traveler: Traveler)->void:
	var ui_traveler_status: UITravelerStatus = preload("uid://cbbpqxpkfqq30").instantiate()
	ui_traveler_status.update_traveler(traveler)
	%GridContainer.add_child(ui_traveler_status)
	
func update_miles(miles: int)->void:
	%MileLbl.text = str("Miles: ", miles)
	
func _on_menu_button_pressed()->void:
	%UIInGameMenu.visible = !%UIInGameMenu.visible
	GameTime.pause()
	
func _on_game_time_starting(hours: float)->void:
	%DayLbl.text = str("Day: ", GameStatus.current_days)
	%HungerLbl.text = str("Hunger: ", GameStatus.current_hunger)
	%GoldLbl.text = str("Gold: ", GameStatus.current_gold)

func _on_ui_hidden()->void:
	hide()
	
func _on_ui_visible()->void:
	show()
