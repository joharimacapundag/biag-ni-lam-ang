extends Node

signal learned_word_added(word)

var travelers_data = preload("res://scripts/json/travelers.json").data
var enemies_data = preload("res://scripts/json/enemies.json").data
var items_data = preload("res://scripts/json/items.json").data
var actions_data = preload("res://scripts/json/actions.json").data
var convinces_data = preload("res://scripts/json/convinces.json").data
var learned_data = preload("res://scripts/json/learn_words.json").data
var talks_data = preload("res://scripts/json/talks.json").data
var items_to_sell = preload("res://scripts/json/items_to_sell.json").data
var travelers = {}

var current_miles: int = 0
var current_act: String = "act_1"
var current_timeline: String = "act_1_scene_2_a"

var current_inventory: Inventory

var current_items: Array
var current_gold: int = 0
var current_learned_words: Array
var current_hunger: int = 0
var current_days: int = 0

func add_learned_word(word: String)->void:
	if !current_learned_words.has(word):
		current_learned_words.append(word)
		learned_word_added.emit(word)

func rest()->void:
	if travelers:
		for traveler in travelers:
			travelers_data[traveler]["health"] = travelers_data[traveler]["max_health"]
			travelers_data[traveler]["stamina"] = travelers_data[traveler]["max_health"]
			travelers_data[traveler]["strenght"] = travelers_data[traveler]["max_health"]
			travelers_data[traveler]["health"] = travelers_data[traveler]["max_health"]
