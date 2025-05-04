extends Node

signal spawned(node)

var events: Dictionary = {
	"act_1": [
		
	{
		"type": "fixed",
		"trigger_mile": 4,
		"scene_path": "uid://bfvqww24w78jl"
	},
	{
		"type": "fixed",
		"trigger_mile": 6,
		"scene_path": "uid://clb2kabkykf3x"
	}, 
	{
		"type": "fixed",
		"trigger_mile": 8,
		"scene_path": "uid://bgb2hkrrd6he7"
	},
	{
		"type": "interval",
		"min_miles": 4,
		"max_miles": 100,
		"chance": 0.75,
		"scene_path": "uid://bsrsqjsesh6nh"
	},
	
	{
		"type": "fixed",
		"trigger_mile": 10,
		"scene_path": "uid://b2mftyjk2o8ry"
	},
	{
		"type": "interval",
		"min_miles": 12,
		"max_miles": 12,
		"chance": 1, 
		"scene_path": "uid://clya8hk4ggrqr"
	},
	{
		"type": "fixed",
		"trigger_mile": 13,
		"scene_path": "uid://bhkjvh4soj304"
	},
	{
		"type": "fixed",
		"min_miles": 16,
		"scene_path": "uid://clya8hk4ggrqr"
	},
	{
		"type": "fixed",
		"trigger_mile": 17,
		"scene_path": "uid://b4fldh0e2ayl7"
	},

	{
		"type": "fixed",
		"trigger_mile": 22,
		"scene_path": "uid://b2tycfqm731ir"
	},
	{
		"type": "fixed",
		"trigger_mile": 24,
		"scene_path": "uid://bj10pnxdjqjo2"
	},
	{
		"type": "fixed",
		"trigger_mile": 28,
		"scene_path": "uid://essqoqb07yl2"
	},
	{
		"type": "interval",
		"min_miles": 30,
		"max_miles": 30,
		"chance": 1, 
		"scene_path": "uid://b1fr2o3dyjpgs"
	},
	],
	"act_2": [
	{
		"type": "fixed",
		"trigger_mile": 32,
		"scene_path": "uid://bfvqww24w78jl"
	},
	{
		"type": "fixed",
		"trigger_mile": 36,
		"scene_path": "uid://clb2kabkykf3x"
	}, 
	{
		"type": "fixed",
		"trigger_mile": 38,
		"scene_path": "uid://deah3nkom2v8t"
	},
	{
		"type": "fixed",
		"trigger_mile": 42,
		"scene_path": "uid://dwfvbqr3iuvya"
	},
	{
		"type": "interval",
		"min_miles": 40,
		"max_miles": 100,
		"chance": 0.75,
		"scene_path": "uid://bsrsqjsesh6nh"
	},
	{
		"type": "fixed",
		"trigger_mile": 44,
		"scene_path": "uid://i6817uwqlknq"
	},
	{
		"type": "interval",
		"min_miles": 48,
		"max_miles": 46,
		"chance": 1, 
		"scene_path": "uid://clya8hk4ggrqr"
	},
	{
		"type": "fixed",
		"trigger_mile": 52,
		"scene_path": "uid://bj10pnxdjqjo2"
	},
	{
		"type": "fixed",
		"trigger_mile": 56,
		"scene_path": "uid://b3vpa80koycfw"
	},
	
	
	],
	"act_3": [
			{
			"type": "interval",
			"min_miles": 58,
			"max_miles": 46,
			"chance": 1, 
			"scene_path": "uid://clya8hk4ggrqr"
		},
		{
			"type": "fixed",
			"trigger_mile":1,
			"scene_path": "uid://lrpu1ybm030y"
		}	
	]
}

var scenes: Dictionary = {
	"lam-ang":{ "scene": preload("uid://bjox6gl6etqg2") },
	"rooster":{ "scene": preload("uid://2pfx7xrsnevs") },
	"doggie":{ "scene": preload("uid://l1k3dnijvyhe") },
	"igorot":{ "scene": preload("uid://c8py4b4778tj8") }
}

func spawn_node(id: String, parent: Node,  position: Vector2) -> void:
	if scenes.has(id):
		
		var instance =  scenes[id]["scene"].instantiate()
		
		if instance is Node2D:
			instance.position = position
			print("success")
			
		parent.add_child(instance)
		spawned.emit(instance)

func mile_spawn(mile: int, act: String, parent: Node2D, position: Vector2) -> void:
	if !events.has(act):
		push_error("No events defined for act: " + act)
		return
	
	for event_data in events[act]:
		if !event_data is Dictionary:
			continue
		
		var event_type = event_data.get("type", "")
		match event_type:
			"fixed":
				if mile == event_data.get("trigger_mile", -1):
					spawn_event(event_data, parent, position)
			"interval":
				var min_miles = event_data.get("min_miles", 0)
				var max_miles = event_data.get("max_miles", 0)
				if mile >= min_miles and mile <= max_miles:
					var chance = event_data.get("chance", 1.0)
					if randf() < chance:
						spawn_event(event_data, parent, position)
			_:
				pass

func spawn_event(event_data: Dictionary, parent: Node, position: Vector2) -> void:
	var scene_path = event_data.get("scene_path")
	var scene = load(scene_path)
	if scene is PackedScene:
		var instance = scene.instantiate()
		if instance is Node2D:
			instance.position = position
			
		parent.add_child(instance)
		spawned.emit(instance)

func spawn(scene_path: String, parent: Node, position: Vector2)->void:
	var scene = load(scene_path)
	if scene is PackedScene:
		var instance = scene.instantiate()
		
		if instance is Node2D:
			instance.position = position
			
		parent.add_child(instance)
		spawned.emit(instance)
