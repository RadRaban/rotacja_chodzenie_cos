extends Node3D

@export var mapa_obrazek: Texture2D
@export var prefab_krzeslo: PackedScene
@export var rozmiar_kraty: float = 1.0

func _ready():
	if not mapa_obrazek:
		print("Brak obrazka mapy!")
		return

	var img: Image = mapa_obrazek.get_image()

	for x in img.get_width():
		for y in img.get_height():
			var color = img.get_pixel(x, y)

			# Sprawdzamy czy piksel jest czerwony
			if color.r > 0.8 and color.g < 0.2 and color.b < 0.2:
				var pozycja = Vector3(x * rozmiar_kraty, 0, y * rozmiar_kraty)
				var krzeslo = prefab_krzeslo.instantiate()
				krzeslo.position = pozycja
				add_child(krzeslo)
