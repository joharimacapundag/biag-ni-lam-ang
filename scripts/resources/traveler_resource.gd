extends Resource
class_name TravelerResource

@export var id: String
@export var name: String
@export var profile: Texture2D
@export var full_body_image: Texture2D
@export_multiline var description: String

@export var actions: Array[String] = []

func create_dictionary(traveler_data: Dictionary)-> Dictionary:
	return traveler_data.get(id, "")
