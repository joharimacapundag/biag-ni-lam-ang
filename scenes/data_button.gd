extends Button
class_name DataButton

var data
signal data_sended(data)

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed()->void:
	data_sended.emit(data)
