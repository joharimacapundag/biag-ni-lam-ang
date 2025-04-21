extends Resource
class_name ItemResource

@export var id: String
@export var name: String
@export_multiline var description: String

func create_dictionary(data: Dictionary)-> Dictionary:
	return data.get("id", "")
