extends CanvasLayer

func _ready():
	visible = false


func _on_about_pressed() -> void:
	visible = true

func _on_button_pressed() -> void:
	visible = false
