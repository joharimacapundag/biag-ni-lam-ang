extends Node

#TravelMode
signal entity_spawned
signal ally_joined
signal item_picked(item)
signal item_used(item)
signal mile_added(value)
signal inventory_updated(inventory)
signal travel_started
signal travel_stopped

#BattleMode
signal battle_entered
signal battle_enemy_entered(enemy)
signal battle_travelers_ready(travelers)
signal traveler_defeated(traveler)
signal battle_action_sended(data)
signal battle_target_selected(target)
signal battle_combat_action_changed(action)
signal battle_support_action_changed(action)
signal battle_item_action_changed(action)
signal battle_started
signal battle_ended(winner)	
signal turn_started(traveler)
signal turn_ended(traveler)
signal next_turn
signal action_selected(action, target)
signal selecting_action_finished
signal action_executed(traveler, action, targets)
signal new_learn_word_added
#Convince Mode
signal convince_entered
signal convince_started
signal convince_ended(success, branch)
