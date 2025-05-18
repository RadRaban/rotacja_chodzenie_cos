extends CharacterBody3D

const SPEED = 4.0
const GRAVITY = 9.8

@onready var head = $Head

func _physics_process(delta):
	# 📌 Odczytaj orientację z czujnika
	var gravity_vec = Input.get_gravity()  # lepsze niż accelerometer
	var gyro = Input.get_gyroscope()

	# 📌 Zamień odczyt na obrót (np. yaw = obrót poziomy)
	var yaw = gyro.y * delta * 5  # w lewo/prawo
	var pitch = gyro.x * delta * 5  # góra/dół

	rotate_y(-yaw)  # obracaj postacią w poziomie
	head.rotate_x(-pitch)  # patrzenie w górę/dół

	# 📌 Poruszanie do przodu jeśli dotykasz ekranu
	if Input.is_action_pressed("touch"):
		var forward = -transform.basis.z
		velocity.x = forward.x * SPEED
		velocity.z = forward.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0

	# 📌 Grawitacja
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0

	move_and_slide()
