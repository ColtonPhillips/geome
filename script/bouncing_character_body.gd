extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 	10.0  # Movement speed
var was_collided = false
var key_index = 0
var last_key_index = -1
func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y -= gravity * delta
	
	# Handle movement input
	
	var input_direction = Vector3.ZERO
	key_index = 0
	if Input.is_action_pressed("ui_left"):
		key_index += 2
		input_direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_direction.x += 1
		key_index += 4
	if Input.is_action_pressed("ui_up"):
		input_direction.z -= 1
		key_index += 8
	if Input.is_action_pressed("ui_down"):
		input_direction.z += 1
		key_index += 16
		
	if key_index != last_key_index:
		was_collided = false
	
	last_key_index = key_index
	
	# Normalize input direction to maintain consistent speed
	if input_direction != Vector3.ZERO:
		input_direction = input_direction.normalized()
	
	# Adjust horizontal velocity based on input
	if not was_collided:
		velocity.x = input_direction.x * speed
		velocity.z = input_direction.z * speed
	
	# Move and detect collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		was_collided = true
		# Reflect velocity on collision
		velocity = velocity.bounce(collision.get_normal())
		
