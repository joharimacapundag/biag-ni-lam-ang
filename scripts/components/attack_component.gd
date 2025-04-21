extends Node
class_name AttackComponent

@export var traveler: Traveler
@export var move_speed = 375  
@export var attack_range = 300  
@export var animated_sprite_2d: AnimatedSprite2D
@export var action_component: ActionComponent

var target: Node2D  
var tween: Tween 
var original_position: Vector2

func _ready():
	tween = traveler.create_tween()
	traveler.attacked.connect(_on_attacked)
	#action_component.action_applied.connect(_on_action_applied)
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	
func perform_attack_action(target_enemy: Node2D) -> void:
	traveler.z_index = 100
	target = target_enemy
	move_towards_target()

func move_towards_target() -> void:
	animated_sprite_2d.play("run")
	original_position = traveler.position
	
	var distance = traveler.position.distance_to(target.position)
	var duration = distance / move_speed
	
	tween = traveler.create_tween().set_parallel(false)
	tween.tween_property(traveler, "position", target.position, duration)
	tween.tween_callback(_on_reach_target)


func _on_reach_target():
	if traveler.position.distance_to(target.position) <= attack_range:
		attack_animation()
	
func _on_attacked(targets: Array)-> void:
	if targets:
		perform_attack_action(targets[0])

func attack_animation() -> void:
	animated_sprite_2d.play("attack")
	await animated_sprite_2d.animation_finished
	reset()

func reset() -> void:
	var return_tween = traveler.create_tween()
	var distance = traveler.position.distance_to(original_position)
	return_tween.tween_property(traveler, "position", original_position, distance / move_speed)
	if !traveler.is_died:
		animated_sprite_2d.play_backwards("run")
		await get_tree().create_timer(0.75).timeout
		animated_sprite_2d.play("idle")

func _on_animation_finished()-> void:
	if target is Traveler:
		target.take_damage()
		traveler.z_index = 1
		traveler.action_finished.emit()
		tween.kill()
		#action_component.action_applied.disconnect(_on_action_applied)
