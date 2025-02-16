extends CharacterBody3D

@export var speed = 10
@export var fall_acceleration = 9.8

@export var mouse_sens := 0.002
var twist_input := 0.0
var pitch_input := 0.0
var click_held = false
var left_click = false

var zoom_speed = 1
var min_distance = 2
var max_distance = 50

var target_velocity = Vector3.ZERO


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				click_held = true;
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			elif event.is_released():
				click_held = false;
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			if event.button_index == MOUSE_BUTTON_LEFT:
				left_click = true;
			else:
				left_click = false;
		
	if event is InputEventMouseMotion:
		if click_held == true:
			twist_input = - event.relative.x * mouse_sens
			pitch_input = - event.relative.y * mouse_sens
			if not left_click:
				$Pivot.rotation = $twist.rotation
	
	if event.is_action_pressed("scroll_up"):
		$twist/pitch/Camera3D.position.z = clamp($twist/pitch/Camera3D.position.z + -zoom_speed, min_distance, max_distance)
	if event.is_action_pressed("scroll_down"):
		$twist/pitch/Camera3D.position.z = clamp($twist/pitch/Camera3D.position.z + zoom_speed, min_distance, max_distance)
		

func _process(delta):
	$twist.rotate_y(twist_input)
	$twist/pitch.rotate_x(pitch_input)
	$twist/pitch.rotation.x = clamp($twist/pitch.rotation.x, deg_to_rad(-89), deg_to_rad(10))
	twist_input = 0.0
	pitch_input = 0.0
	


func _physics_process(delta):
	var input = Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = -Input.get_axis("move_forward", "move_back")
	if input != Vector3.ZERO:
		input = input.normalized()
		input *= $twist.basis
		# what the fuck
		input.z *= -1
		if not click_held or left_click:
			var target_position = global_transform.origin + input.normalized()
			target_position.y = global_transform.origin.y
			$Pivot.look_at(target_position, Vector3.UP)
	target_velocity.x = input.x * speed
	target_velocity.z = input.z * speed

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	velocity = target_velocity
	move_and_slide()
