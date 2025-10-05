class_name spawner extends Node2D

@export var num_monsters: int = 10

var enemy = preload("res://Enemy/Enemy.tscn")

func _ready() -> void:
	spawn_enemies()

func spawn_enemies() -> void:
	for i in num_monsters:
		var obj = enemy.instantiate()
		
		# Losowa pozycja w promieniu od spawnera
		var random_offset = Vector2(
			randf_range(0, get_viewport_rect().size[0]),
			randf_range(0, get_viewport_rect().size[1])
		)
		
		obj.global_position = random_offset
		get_tree().root.get_node("Playground").add_child.call_deferred(obj)
