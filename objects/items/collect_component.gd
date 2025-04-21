extends Node
class_name CollectComponent

@export var area_2d: Area2D
@export var item: Item

func _ready() -> void:
	if area_2d :
		area_2d.area_entered.connect(_on_area_entered)

func _on_area_entered(area_2d: Area2D)->void:
	if area_2d.get_parent().is_in_group("player"):
		if owner is Item:	
			item.collected = true
			var picked_item: Dictionary = { }
			picked_item.merge({"id": item.item_resource.id})
			picked_item.merge(item.item_dict)
			GameEvents.item_picked.emit(picked_item)
			if !GameStatus.current_learned_words.has(item.item_resource.id) && item.canvas_layer && item.picked_up_label:
				GameStatus.add_learned_word(item.item_resource.id)
				GameEvents.new_learn_word_added.emit(item.item_resource.id)
				
