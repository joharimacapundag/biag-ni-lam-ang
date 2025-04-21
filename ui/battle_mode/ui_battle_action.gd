extends PanelContainer

@export var category_name: String = "Category"
var current_data_selected: Dictionary = {}

func _ready() -> void:
	%DataButton.data_sended.connect(_on_data_sended)
	%Label.text = category_name
	
func update_action(action: Dictionary)->void:
	%DataButton.text = action["ilocano_word"]
	%DataButton.data = action

func _on_data_sended(data)->void:
	GameEvents.battle_action_sended.emit(data)
	
