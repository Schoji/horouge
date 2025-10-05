extends GPUParticles2D

func _ready() -> void:
	# Podstawowe ustawienia
	amount = 200  # Ilość kropli - zmniejsz dla lżejszego deszczu
	lifetime = 2.0
	preprocess = 1.0
	explosiveness = 0.0
	randomness = 0.3
	
	# Ustawienia procesu
	process_material = create_rain_material()
	
	# Wielkość obszaru emisji (cały ekran + margines)
	var screen_size = get_viewport_rect().size
	
	# Ustawienia emisji
	var emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	var emission_box = Vector3(screen_size.x / 2 + 100, 10, 0)
	
	# Pozycja na środku ekranu, u góry
	position = Vector2(screen_size.x / 2, -20)

func _process(_delta: float) -> void:
	# Aktualizuj pozycję żeby deszcz był zawsze nad ekranem
	var screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x / 2, -20)

func create_rain_material() -> ParticleProcessMaterial:
	var material = ParticleProcessMaterial.new()
	
	# Obszar emisji (box na górze ekranu)
	var screen_size = get_viewport_rect().size
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	material.emission_box_extents = Vector3(screen_size.x / 2 + 100, 10, 0)
	
	# Kierunek spadania
	material.direction = Vector3(0, 1, 0)  # W dół
	material.spread = 2.0  # Minimalny rozrzut
	
	# Prędkość
	material.initial_velocity_min = 200.0
	material.initial_velocity_max = 300.0
	
	# Grawitacja (dodatkowe przyspieszenie w dół)
	material.gravity = Vector3(0, 98, 0)
	
	# Rozmiar kropli
	material.scale_min = 0.5
	material.scale_max = 1.5
	
	# Kolor - niebieskawa kropla
	material.color = Color(0.7, 0.8, 1.0, 0.6)
	
	# Liniowy spadek (kropla wydłuża się podczas lotu)
	material.scale_curve = create_scale_curve()
	
	return material

func create_scale_curve() -> Curve:
	var curve = Curve.new()
	curve.add_point(Vector2(0, 1.0))
	curve.add_point(Vector2(1, 1.0))
	return curve

func create_rain_texture() -> Texture2D:
	# Tworzymy prostą teksturę kropli (pionowa linia)
	var img = Image.create(4, 16, false, Image.FORMAT_RGBA8)
	
	for y in range(16):
		var alpha = 1.0 - (float(y) / 16.0) * 0.3  # Górna część bardziej widoczna
		img.set_pixel(1, y, Color(1, 1, 1, alpha))
		img.set_pixel(2, y, Color(1, 1, 1, alpha))
	
	return ImageTexture.create_from_image(img)
