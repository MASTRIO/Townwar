extends Camera2D

const SPEED = 500

func _physics_process(delta):
	if Input.is_action_just_pressed("reset_camera"):
		position = Vector2(0, 0)
	
	if Input.is_action_pressed("pan_left"):
		position.x -= SPEED * delta
	elif Input.is_action_pressed("pan_right"):
		position.x += SPEED * delta
