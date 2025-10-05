extends Node

@onready var hearts_container: HBoxContainer = $CanvasLayer/HeartsContainer
@onready var player: Player = $Player

func _ready() -> void:
	hearts_container.setMaxHearts(player.max_hp)
	hearts_container.updateHearts(player.hp)
	player.healthChanged.connect(hearts_container.updateHearts)
