extends Node2D
class_name BattleMode

@export var turn_queue_component: TurnQueueComponent

var travelers: Array[Traveler] = []
var turn_queue = []
var current_traveler: Traveler
var current_action: Dictionary = {}
var current_target_selected

func _ready() -> void:
	GameEvents.battle_enemy_entered.connect(_on_battle_enemy_entered)
	GameEvents.battle_started.connect(_on_battle_started)
	GameEvents.battle_action_sended.connect(_on_battle_action_sended)
	GameEvents.battle_target_selected.connect(_on_battle_target_selected)
	GameEvents.battle_started.emit()
	
func _on_battle_started()->void:
	%Camera2D.make_current()
	self.spawn_player()
	
	await GameEvents.battle_enemy_entered
	append_all_travelers()
	
	%UIBattleMode.add_enemies( travelers.filter(func(elem)-> bool: return elem.is_in_group("enemy")))
	
	turn_queue = turn_queue_component.initialize_turn_order(travelers)
	process_next_turn()

func append_all_travelers()->void:
	for child in get_children():
		if child is Traveler:
			travelers.append(child)
	GameEvents.battle_travelers_ready.emit(travelers)		
	
func _on_battle_enemy_entered(enemy)->void:
	if GameStatus.enemies_data.has(enemy):
		var enemies: Array = GameStatus.enemies_data[enemy]
		var i = 1
		for opponent in enemies:
			if %Enemies.has_node(str("Enemy", i)):
				%Enemies.get_node(str("Enemy", i)).spawn(opponent)
			i +=1
	
func spawn_player()->void:
	if GameStatus.travelers.has("lam-ang"):
		%Player1.spawn("b_lam-ang")
	if GameStatus.travelers.has("rooster"):
		%Player2.spawn("b_rooster")
	if GameStatus.travelers.has("doggie"):
		%Player3.spawn("b_doggie")
		
func process_next_turn():
	if turn_queue.size() > 0:
		current_traveler = turn_queue[0]
		GameEvents.turn_started.emit(current_traveler)
	else:
		check_battle_state()

func end_turn():
	GameEvents.turn_ended.emit(current_traveler)
	turn_queue.push_back(turn_queue.pop_front())  
	GameEvents.next_turn.emit()
	process_next_turn()

func _on_battle_action_sended(action)->void:
	current_action = action

func _on_battle_target_selected(target)->void:
	current_target_selected = target
	select_action(current_action, [target])
	
func select_action(action: Dictionary, targets: Array):
	GameEvents.action_selected.emit(action, targets)
	GameEvents.action_executed.emit(current_traveler, action, targets)

func traveler_defeat(traveler):
	GameEvents.traveler_defeated.emit(traveler)
	turn_queue.erase(traveler)
	check_battle_state()

func check_battle_state():
	if all_players_defeated():
		GameEvents.battle_ended.emit("enemy")
	elif all_enemies_defeated():
		GameEvents.battle_ended.emit("player")
		
func all_players_defeated()-> bool:
	for traveler in travelers:
		if traveler.is_in_group("player"):
			return false
	return true

func all_enemies_defeated()-> bool:
	for traveler in travelers:
		if traveler.is_in_group("enemy"):
			return false
	return true
