class_name HitBox extends Area2D

signal Damaged( damage: int)

func TakeDamage( damage: int ) -> void:
	print("Took Damage: ", damage)
	Damaged.emit(damage)
	
 
