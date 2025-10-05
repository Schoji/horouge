extends Panel

@onready var sprite = $Sprite2D

func update(whole: bool):
	if whole == true:
		sprite.frame = 4
	else: 
		sprite.frame = 0
