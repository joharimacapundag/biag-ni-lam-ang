extends Node

var scene_stack := []

func push_scene(scene_path: String):
	var new_scene = load(scene_path).instantiate()
	add_child(new_scene)
	scene_stack.append(new_scene)
	
func pop_scene():
	if scene_stack.is_empty():
		return

	var top_scene = scene_stack.pop_back()
	top_scene.queue_free()
