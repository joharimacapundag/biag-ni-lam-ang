extends Node
class_name TravelMode

@export var mile_spawn_trigger_component: MileSpawnTriggerComponent
@export var node_to_hide: Node2D

var lead_traveler: Node2D

func _ready() -> void:
	GameEvents.travel_started.connect(_on_travel_started)
	GameEvents.travel_stopped.connect(_on_travel_stopped)
	GameEvents.battle_entered.connect(_on_battle_entered)
	GameEvents.battle_ended.connect(_on_battle_ended)
	GameEvents.convince_entered.connect(_on_convince_entered)
	GameEvents.convince_ended.connect(_on_convince_ended)
	GameEvents.entity_spawned.connect(_on_entity_spawned)
	GameEvents.mile_added.connect(_on_mile_added)
	GameEvents.ally_joined.connect(_on_ally_joined)
	GameTime.game_time_paused.connect(_on_game_time_paused)
	GameTime.game_time_unpaused.connect(_on_game_time_unpaused)
	GameTime.game_time_starting.connect(_on_game_time_starting)
	GameEvents.item_used.connect(_on_item_used)
	GameSpawner.spawned.connect(_on_spawned)
	%EntitySpawner.spawn("lam-ang")
	update_travelers()
	await get_tree().create_timer(1)
	GameTime.unpause()

func _on_game_time_starting(hours: float)->void:
	pass
func _on_item_used(item: InventoryItem)->void:
	%ItemUsedLabel.text = str("Item Used: ", str("\"", item.get_property("name"), "\"" ).capitalize())
	%ItemUsed.show()
	await get_tree().create_timer(2).timeout
	%ItemUsed.hide()
	
func _on_game_time_paused()->void:
	GameEvents.travel_stopped.emit()

func _on_game_time_unpaused()->void:
	GameEvents.travel_started.emit()

func _on_travel_started()->void:
	%AudioStreamPlayer2D.play()
	pass

func _on_travel_stopped()->void:
	%AudioStreamPlayer2D.stop()
	pass

	
func _on_battle_entered()->void:
	await get_tree().create_timer(1).timeout
	%CanvasLayer.hide()
	node_to_hide.hide()

func _on_battle_ended(winner)->void:
	check_travelers()
	await get_tree().create_timer(3).timeout
	%CanvasLayer.show()
	%Camera2D.make_current()
	node_to_hide.show()
	await get_tree().create_timer(2).timeout
	
func _on_convince_entered()->void:
	await get_tree().create_timer(1).timeout
	%CanvasLayer.hide()
	node_to_hide.hide()

func _on_convince_ended(success, branch)->void:
	await get_tree().create_timer(3).timeout
	%CanvasLayer.show()
	%Camera2D.make_current()
	node_to_hide.show()
	await get_tree().create_timer(2).timeout

func _on_ally_joined(id)->void:
	await get_tree().create_timer(2).timeout
	match id:
		"rooster": 
			GameSpawner.spawn_node(id, self, lead_traveler.position - Vector2(50, 25))
			%AllyJoinUILabel.text = "ROOSTER joined the party"
			%AllyJoinUI.show()
		"doggie": 
			GameSpawner.spawn_node(id, self, lead_traveler.position + Vector2(50, 25))
			%AllyJoinUILabel.text = "DOGGIE joined the party"
			%AllyJoinUI.show()
	await get_tree().create_timer(3).timeout
	%AllyJoinUI.hide()
	
	
func _on_entity_spawned(entity)->void:
	if entity is Traveler:
		if entity.traveler_resource.id == "lam-ang":
			lead_traveler = entity
			mile_spawn_trigger_component.traveler = lead_traveler
			
func check_travelers()->void:
	for child in get_children():
		if child is Traveler:
			if child.traveler_resource.id == "lam-ang":
				lead_traveler = child
				mile_spawn_trigger_component.traveler = lead_traveler
				
			
func _on_spawned(entity)->void:
	if entity is Traveler:
		if entity.is_in_group("player"):
			%UITravelMode.add_traveler(entity)
		
func _on_mile_added(miles: int)->void:
	%UITravelMode.update_miles(miles)
	
func update_travelers()->void:
	%UITravelMode.add_travelers(get_children().filter(func(elem)->bool: return elem.is_in_group("player")))
