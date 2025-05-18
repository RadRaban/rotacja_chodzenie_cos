extends CharacterBody3D

const SPEED = 4.0
const GRAVITY = 9.8
@onready var head = $Head



func _physics_process(delta):
	# Grawitacja
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0

	# Obracanie kamerą przez akcelerometr (poniżej poprawimy oś Y)
	var gyro = Input.get_gyroscope()
	var yaw = gyro.y * delta * -5
	var pitch = gyro.x * delta * -5

	rotate_y(-yaw)
	head.rotate_x(-pitch)

	# 👉 Ruch do przodu po dotknięciu ekranu
	if Input.is_action_pressed("touch"):
		var forward = -transform.basis.z
		velocity.x = forward.x * SPEED
		velocity.z = forward.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0
		
	
	move_and_slide()
	
func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed:
		print("Ekran dotknięty!")

	if event is InputEventMouseButton and event.pressed:
		print("Kliknięcie myszy!")
