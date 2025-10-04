class_name State extends Node

static var player: Player

func _ready() -> void:
	pass

func Enter() -> void:
	pass

func Exit() -> void:
	pass
	
func Process(_delta: float) -> State:
	return null
	
func Physics(_delta: float) -> State:
	return null
	
func handleInput(_event: InputEvent):
	return null
