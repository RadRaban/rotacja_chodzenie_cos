extends CharacterBody3D

const SPEED = 4.0
const GRAVITY = 9.8
@onready var head = $Head

var pitch_angle = 0.0
var MAX_PITCH = deg_to_rad(80.0)
var MIN_PITCH = deg_to_rad(-80.0)

# Czułość
var ROTATE_SPEED = 2.5   # obrót gracza (lewo/prawo) – akcelerometr
var PITCH_SPEED = 5.0    # obrót kamery (góra/dół) – żyroskop

func _physics_process(delta):
	# Grawitacja
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0

	# 📱 Akcelerometr – pochylanie telefonu lewo/prawo (do obracania gracza)
	var accel = Input.get_accelerometer()
	var roll = accel.x  # ←→

	# 📱 Żyroskop – obracanie telefonu (do kamery góra/dół)
	var gyro = Input.get_gyroscope()
	var pitch_delta = gyro.x * PITCH_SPEED * delta

	# ✅ Obracamy gracza lewo/prawo cały czas, gdy ekran pochylony
	rotate_y(-roll * ROTATE_SPEED * delta)

	# ✅ Kamera – obrót góra/dół z limitem
	pitch_angle = clamp(pitch_angle + pitch_delta, MIN_PITCH, MAX_PITCH)
	head.rotation.x = pitch_angle

	# 👉 Ruch do przodu przy dotknięciu ekranu
	if Input.is_action_pressed("touch"):
		var forward = -transform.basis.z
		velocity.x = forward.x * SPEED
		velocity.z = forward.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
