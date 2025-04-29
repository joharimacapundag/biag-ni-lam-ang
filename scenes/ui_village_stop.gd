extends Control

var current_talks: Array = []

func _on_talk_btn_pressed() -> void:
	%GridContainer.get_children().clear()
	await get_tree().create_timer(0.5).timeout
	%PanelContainer2.hide()
	await get_tree().create_timer(0.5).timeout
	%PanelContainer2.show()
	GameStatus.current_act = "act_2"
	for child in GameStatus.talks_data[GameStatus.current_act]["talk_pressed"]:
		var btn: DataButton = DataButton.new()
		btn.text = child
		btn.data = child
		btn.data_sended.connect(_on_talked_data_sended)
		if !current_talks.has(child):
			%GridContainer.add_child(btn)
			current_talks.append(child)
		
func _on_talked_data_sended(data)->void:
	if GameStatus.talks_data[GameStatus.current_act]["talk_pressed"][data]:
		var scene_path: String = GameStatus.talks_data[GameStatus.current_act]["talk_pressed"][data]["scene_path"]
		get_tree().change_scene_to_file(scene_path)

func _on_shop_btn_pressed() -> void:
	pass # Replace with function body.


func _on_rest_btn_pressed() -> void:
	for traveler in GameStatus.travelers:
		traveler["health"] = traveler["max_health"]
		traveler["stamina"] = traveler["max_stamina"]
		traveler["strength"] = traveler["max_strength"]
		traveler["defense"] = traveler["max_defense"]
		traveler["speed"] = traveler["max_speed"]
