extends PointLight2D

@onready var player: Player = get_parent()

func _ready() -> void:
	# Ustaw pozycję na centrum gracza
	position = Vector2.ZERO
	
	# Przesuń offset tekstury żeby stożek zaczynał się od gracza
	offset = Vector2(192, 0)  # To jest klucz! Przesuwamy teksturę w prawo
	
	# Konfiguracja światła - mniejszy zasięg
	energy = 0.8
	range_item_cull_mask = 1
	shadow_enabled = false
	color = Color(1, 0.98, 0.9)
	
	# Tworzymy własną teksturę stożka
	texture = create_cone_gradient()
	texture_scale = 1.5

func _process(_delta: float) -> void:
	# Aktualizacja kierunku latarki na podstawie cardinal_direction gracza
	match player.cardinal_direction:
		Vector2.DOWN:
			rotation_degrees = 90
			position = Vector2(0, 6)  # Dostosuj te wartości
		Vector2.UP:
			rotation_degrees = -90
			position = Vector2(0, -6)  # Dostosuj te wartości
		Vector2.LEFT:
			rotation_degrees = 180
			position = Vector2(-1, 0)  # Dostosuj te wartości
		Vector2.RIGHT:
			rotation_degrees = 0
			position = Vector2(1, 0)  # Dostosuj te wartości

func create_cone_gradient() -> Texture2D:
	# Tworzymy obrazek tekstury stożka
	var img = Image.create(256, 256, false, Image.FORMAT_RGBA8)
	
	var center = Vector2(0, 128) # Lewy środek
	var cone_angle = 60.0 # Kąt stożka w stopniach
	var cone_length = 256.0
	var min_distance = 5.0 # Obcięcie od strony gracza - TUTAJ!
	
	for x in range(256):
		for y in range(256):
			var pos = Vector2(x, y)
			var to_pixel = pos - center
			var distance = to_pixel.length()
			var angle = rad_to_deg(to_pixel.angle())
			
			# Normalizuj kąt do zakresu -180 do 180
			while angle > 180:
				angle -= 360
			while angle < -180:
				angle += 360
			
			# Sprawdź czy piksel jest w stożku I czy jest dalej niż min_distance
			if abs(angle) <= cone_angle / 2.0 and distance <= cone_length and distance >= min_distance:
				# Oblicz intensywność na podstawie odległości i kąta
				var distance_falloff = 1.0 - (distance / cone_length)
				var angle_falloff = 1.0 - (abs(angle) / (cone_angle / 2.0))
				var intensity = distance_falloff * angle_falloff
				intensity = pow(intensity, 1.5) # Mocniejszy spadek
				
				var alpha = clamp(intensity, 0.0, 1.0)
				img.set_pixel(x, y, Color(1, 1, 1, alpha))
			else:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
	
	return ImageTexture.create_from_image(img)
