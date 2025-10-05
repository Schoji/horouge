extends Camera2D

@export var smoothing_enabled: bool = true
@export var smoothing_speed: float = 5.0

var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	enabled = true
	position_smoothing_enabled = smoothing_enabled
	position_smoothing_speed = smoothing_speed

func move_to_position(new_position: Vector2) -> void:
	target_position = new_position
	position = new_position
