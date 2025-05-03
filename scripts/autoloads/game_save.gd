extends Node

signal game_saved
signal game_loaded

const SAVE_FILE_PATH: String = "user://savegame.save"

func save_game():
	var config = ConfigFile.new()
	config.set_value("global", "act", GameStatus.current_act)
	config.set_value("global", "days", GameStatus.current_days)
	config.set_value("global", "hunger", GameStatus.current_hunger)
	config.set_value("global", "gold", GameStatus.current_gold)
	config.set_value("global", "miles", GameStatus.current_miles)
	config.set_value("global", "travelers", GameStatus.travelers)
	config.save("user://global.cfg")
	
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data = node.call("save")

		var json_string = JSON.stringify(node_data)

		save_file.store_line(json_string)
	game_saved.emit()
  
func load_game():
	
	var config = ConfigFile.new()
	var err = config.load("user://global.cfg")
	
	if err != OK:
		return

	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return 
		
	for global in config.get_sections():
		GameStatus.current_act =  config.get_value(global, "act")
		GameStatus.current_days = config.get_value(global, "days")
		GameStatus.current_hunger = config.get_value(global, "hunger")
		GameStatus.current_gold = config.get_value(global, "gold")
		GameStatus.current_miles = config.get_value(global, "miles")
		GameStatus.travelers = config.get_value(global, "travelers")
		
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var node_data = json.data

		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
		
	game_loaded.emit()
