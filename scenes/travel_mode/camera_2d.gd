extends Camera2D

@export_range(-1, 1) var direction: int
@export_range(0, 999) var speed: int

var is_running: bool

func _ready() -> void:
	GameEvents.travel_started.connect(_on_travel_started)
	GameEvents.travel_stopped.connect(_on_travel_stopped)

func _on_travel_started()->void:
	is_running = true
	direction = 1
	
func _on_travel_stopped()->void:
	is_running = false
	direction = 0

func _process(delta: float) -> void:
	if is_running:
		position.x += direction * speed * delta
