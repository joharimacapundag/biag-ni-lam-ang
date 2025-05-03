extends Node2D

func _ready() -> void:
	pass

func _on_ui_main_menu_start_button_pressed() -> void:
	%UIMainMenu.hide()
	%UIUserMode.show()
	
func _on_ui_main_menu_continue_button_pressed() -> void:
	GameSave.load_game()
	hide()
	%CanvasLayer.hide()

func _on_ui_main_menu_load_button_pressed() -> void:
	GameSave.load_game()
	hide()
	%CanvasLayer.hide()
func _on_ui_main_menu_quit_button_pressed() -> void:
	get_tree().quit()
