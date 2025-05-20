extends CharacterBody3D

const SPEED = 4.0
const GRAVITY = 9.8
@onready var head = $Head

var pitch_angle = 0.0
var MAX_PITCH = deg_to_rad(80.0)
var MIN_PITCH = deg_to_rad(-80.0)

# Czułość
var ROTATE_SPEED = 2.5  # akcelerometr – obrót gracza
var PITCH_SPEED = 5.0   # żyroskop – kamera góra/dół
var MOUSE_SENS = 0.002  # czułość myszy

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().quit()  # Zamknij grę
		
	if event is InputEventMouseMotion:
		# Obrót gracza lewo/prawo
		rotate_y(-event.relative.x * MOUSE_SENS)
		
		# Obrót kamery góra/dół
		pitch_angle = clamp(pitch_angle - event.relative.y * MOUSE_SENS, MIN_PITCH, MAX_PITCH)
		head.rotation.x = pitch_angle

func _physics_process(delta):
	# Grawitacja
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0

	# 📱 Akcelerometr – pochylanie telefonu lewo/prawo
	var accel = Input.get_accelerometer()
	var roll = accel.x
	rotate_y(-roll * ROTATE_SPEED * delta)

	# 📱 Żyroskop – obrót kamery góra/dół
	var gyro = Input.get_gyroscope()
	var pitch_delta = gyro.x * PITCH_SPEED * delta
	pitch_angle = clamp(pitch_angle + pitch_delta, MIN_PITCH, MAX_PITCH)
	head.rotation.x = pitch_angle

	# 👉 Ruch – dotyk (do przodu) + WASD
	var direction = Vector3.ZERO

	# Ekran dotknięty – do przodu
	if Input.is_action_pressed("touch"):
		direction -= transform.basis.z

	# Klawiatura – WASD
	if Input.is_action_pressed("ui_up"):
		direction -= transform.basis.z
	if Input.is_action_pressed("ui_down"):
		direction += transform.basis.z
	if Input.is_action_pressed("ui_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("ui_right"):
		direction += transform.basis.x

	direction = direction.normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()
