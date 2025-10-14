extends CanvasLayer

signal showHearts()

func _ready() -> void:
	get_tree().paused = true
	

func _on_play_pressed() -> void:
	get_tree().paused = false
	self.hide()
	showHearts.emit()
	
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_about_pressed() -> void:
	visible = false

func _on_back_pressed() -> void:
	visible = true
