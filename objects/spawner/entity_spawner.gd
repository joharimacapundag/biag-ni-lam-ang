extends Marker2D
class_name EntitySpawner

var entities: Dictionary = {
	"lam-ang":{ "scene": preload("uid://bjox6gl6etqg2") },
	"rooster":{ "scene": preload("uid://2pfx7xrsnevs") },
	"doggie":{ "scene": preload("uid://l1k3dnijvyhe") },
	"igorot":{ "scene": preload("uid://c8py4b4778tj8") },
	"b_lam-ang":{ "scene": preload("uid://bbsr170vxrutp") },
	"b_rooster":{ "scene": preload("uid://rwgiea3y5ric") },
	"b_doggie":{ "scene": preload("uid://2bigrjgf5crm") },
	"berkakan": {"scene": preload("uid://j8h7p2ju275t")}
}
	
func spawn(id: String)->void:
	if entities.has(id):
		var instance =  entities[id]["scene"].instantiate()
		
		if instance is Node2D:
			instance.position = position
			
		owner.add_child(instance)
		GameEvents.entity_spawned.emit(instance)
