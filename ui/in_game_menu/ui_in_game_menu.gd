extends Control

signal action_used(action_name: String, targets: Array)

var current_travelers = []
var current_traveler_selected: Traveler
var current_item_selected: InventoryItem
var current_learned_words = []

func _ready() -> void:
	GameEvents.item_picked.connect(_on_item_picked)
	GameEvents.travel_started.connect(_on_travel_started)
	GameEvents.travel_stopped.connect(_on_travel_stopped)
	GameStatus.learned_word_added.connect(_on_learned_word_added)
	
func _on_travel_stopped()->void:
	for word in GameStatus.current_learned_words:
		var button = DataButton.new()
		var name = word
		button.text = name.capitalize()
		button.data = word
		button.data_sended.connect(_on_word_data_sended)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		if !current_learned_words.has(word):
			current_learned_words.append(word)
			%WordsContainer.add_child(button)
					
	
func _on_learned_word_added(word)->void:
	pass
	
func _on_word_data_sended(word)->void:
	if GameStatus.learned_data.has(word):
		%IlocanoWordLbl.text = str("Ilocano Word:", GameStatus.learned_data[word]["ilocano_word"])
		%WordDescription.text = GameStatus.learned_data[word]["description"]

func _on_tab_container_tab_clicked(tab: int) -> void:
	if tab == 5:
		hide()
		%TabContainer.current_tab = 1
		GameTime.unpause()
		
func _on_item_picked(item)->void:
	%Inventory.create_and_add_item(item["id"])
	GameStatus.current_inventory = %Inventory

func _on_travel_started()->void:
	update_ui_travelers()
	
func update_ui_travelers()->void:
	var nodes = get_tree().get_nodes_in_group("player")
	if nodes:
		for child in nodes:
			if child is Traveler:
				var button = DataButton.new()
				var name = child.traveler_resource.name
				button.text = name.capitalize()
				button.custom_minimum_size = Vector2(100, 100)
				button.data = child
				button.data_sended.connect(_on_data_sended)
				
				var item_trav_button = DataButton.new()
				var item_trav_name = child.traveler_resource.name
				item_trav_button.text = name.capitalize()
				item_trav_button.custom_minimum_size = Vector2(100, 100)
				item_trav_button.data = child
				item_trav_button.data_sended.connect(_on_data_sended)
				
				if !current_travelers.has(child.traveler_resource.id):
					current_travelers.append(child.traveler_resource.id)
					%HBoxContainer.add_child(button)
					%TargetsContainer.add_child(item_trav_button)
					
func _on_data_sended(data)->void:
	if data is Traveler:
		current_traveler_selected = data
		print(current_traveler_selected.traveler_resource.name)
		%UseButton.disabled = false
		%TravelerNameLbl.text = data.traveler_resource.name
		%TravelerNameContainer.show()
		%TravelerStatusContainer.show()
		
		%DescriptionLabel.show()
		var traveler: Dictionary = GameStatus.travelers[data.traveler_resource.id]
		%HealthBar.value = float(traveler["health"])/ float(traveler["max_health"]) * 100
		%StaminaBar.value = float(traveler["stamina"])/ float(traveler["max_stamina"]) * 100
		%StrengthBar.value = float(traveler["strength"])/ float(traveler["max_strength"]) * 100
		%DefenseBar.value = float(traveler["defense"])/ float(traveler["max_defense"]) * 100
		%FullBodyImage.texture = data.traveler_resource.full_body_image
		%DescriptionLabel.text = data.traveler_resource.description


func _on_ctrl_inventory_grid_inventory_item_clicked(item: InventoryItem) -> void:
	pass

func _on_ctrl_inventory_grid_inventory_item_selected(item: InventoryItem) -> void:
	current_item_selected = item
	if current_item_selected:
		%ItemLabel.show()
		%ItemDescriptionLabel.show()
		%TargetsContainer.show()
		%UseButton.show()
		%ItemLabel.text = item.get_property("name")
		%ItemDescriptionLabel.text = item.get_property("description")
	else:
		%ItemLabel.hide()
		%ItemDescriptionLabel.hide()
		%TargetsContainer.hide()
		%UseButton.hide()
		%ItemLabel.text = item.get_property("name")
		%ItemDescriptionLabel.text = item.get_property("description")

func _on_use_button_pressed() -> void:
	if current_traveler_selected && current_item_selected:
		%InGameTraveler.use_action(str(current_item_selected.get_property("name")).to_lower(), [current_traveler_selected])
		GameEvents.item_used.emit(current_item_selected)
		%Inventory.remove_item(current_item_selected)
		
		
func _on_visibility_changed() -> void:
	pass
		
func use_action(action_name: String, targets: Array) -> void:
	action_used.emit(action_name, targets)
