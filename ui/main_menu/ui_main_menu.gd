extends Control

signal start_button_pressed
signal continue_button_pressed
signal load_button_pressed
signal quit_button_pressed

func _ready() -> void:
	%StartBtn.pressed.connect(_on_start_btn_pressed)
	%ContinueBtn.pressed.connect(_on_continue_btn_pressed)
	%LoadBtn.pressed.connect(_on_load_btn_pressed)
	%QuitBtn.pressed.connect(_on_quit_btn_pressed)

func _on_start_btn_pressed()->void:
	start_button_pressed.emit()

func _on_continue_btn_pressed()->void:
	continue_button_pressed.emit()

func _on_load_btn_pressed()->void:
	load_button_pressed.emit()

func _on_quit_btn_pressed()->void:
	quit_button_pressed.emit()
	
