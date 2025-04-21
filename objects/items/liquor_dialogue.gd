extends Node
class_name TriggerDialogue
@export var item: Item


func _ready() -> void:
	GameEvents.new_learn_word_added.connect(_on_learn_word_added)

func _on_learn_word_added(word)->void:
	if word && item.collected:
		Dialogic.start(str(word,"_dialogue"))
		GameTime.pause()
		await Dialogic.timeline_ended
		item.picked_up_label.text = str("New word: ", item.item_resource.name)
		item.canvas_layer.show()
		await get_tree().create_timer(1).timeout
		GameTime.unpause()
		item.queue_free()
	
			
