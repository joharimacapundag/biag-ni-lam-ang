extends Node2D
class_name Traveler

signal died

signal damage_taken
signal damage_taken_finished

signal travel_started
signal travel_stopped

signal attacked(targets: Array)
signal healed

signal direction_changed(value: int)

signal action_used(action_name: String, targets: Array)
signal action_finished

@export var traveler_resource: TravelerResource

var is_died: bool

func _ready() -> void:
	GameEvents.travel_started.emit(_on_travel_started)
	GameEvents.travel_stopped.emit(_on_travel_stopped)

func _on_travel_started()-> void:
	travel_started.emit()
	
func _on_travel_stopped() -> void:
	travel_stopped.emit()
	
func use_action(action_name: String, targets: Array) -> void:
	action_used.emit(action_name, targets)

func attack(targets: Array)-> void:
	attacked.emit(targets)

func heal()-> void:
	healed.emit()

func take_damage()-> void:
	damage_taken.emit()

func change_direction(value: int)-> void:
	direction_changed.emit(value)
	
func die() -> void:
	is_died = true
	died.emit()
	#process_mode = ProcessMode.PROCESS_MODE_DISABLED
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
	}
	return save_dict
