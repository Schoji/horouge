extends HBoxContainer

@onready var HeartGuiClass = preload("res://heart_gui.tscn")
@onready var main_menu: CanvasLayer = $"../../MainMenu"


func _ready() -> void:
	main_menu.showHearts.connect(showeq)
	self.hide()

func showeq() -> void:
	self.show()

func setMaxHearts(max_hearts: int):
	for i in range(max_hearts):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)

func updateHearts(currentHealth: int):
	var hearts = get_children()
	for i in range(currentHealth):
		hearts[i].update(true)
	
	for i in range(currentHealth, hearts.size()):
		hearts[i].update(false)
	
	
