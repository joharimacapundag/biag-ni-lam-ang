extends Node2D
class_name Item
	
@export var item_resource: ItemResource
@export var sprite_2d: Sprite2D
@export var canvas_layer: CanvasLayer
@export  var picked_up_label: Label 
var item_dict: Dictionary = {}
var collected: bool

func _ready() -> void:
	item_dict = GameStatus.items_data[item_resource.id]
	
	if item_dict:
		item_resource.name = item_dict["name"]
		print(item_resource.name, " Spawned")
		sprite_2d.texture  = load(item_dict["image"])
	
