extends AudioStreamPlayer

@export var music_file: AudioStream

func _ready() -> void:
	if music_file:
		stream = music_file
	play()
