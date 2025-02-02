extends RigidBody3D

# Adjustable properties for gameplay tweaking
@export var speed: float = 30.0  # Speed multiplier for player input
@export var jump_strength: float = 600.0  # Strength of the jump
@export var camera: Camera3D

# Physics material for the marble
func _ready():
	pass

func _physics_process(delta):
	# Apply player input
	handle_input(delta)

var jump_direction = Vector3(0,0,0)
func _integrate_forces(state: PhysicsDirectBodyState3D):
	var normal_temp = Vector3()
	for i in range(state.get_contact_count()):
		var body = state.get_contact_collider_object(i)  # Get the colliding body
		var normal = state.get_contact_local_normal(i)  # Get the normal
		normal_temp += normal
	if state.get_contact_count() != 0:
		normal_temp /= state.get_contact_count()
		jump_direction = normal_temp.normalized()

func handle_input(delta):
	# Get player input for movement
	var direction = Vector3.ZERO
	# Hard-coded WASD keys
	if Input.is_key_pressed(KEY_W):
		direction.z -= 1  # Move forward
	if Input.is_key_pressed(KEY_S):
		direction.z += 1  # Move backward
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1  # Move left
	if Input.is_key_pressed(KEY_D):
		direction.x += 1  # Move right
	direction = direction.normalized()
#

	# Apply directional force relative to the camera
	if direction != Vector3.ZERO and camera:
		# Get the camera's forward and right vectors
		var camera_forward = camera.global_transform.basis.z.normalized()
		var camera_right = camera.global_transform.basis.x.normalized()

		# Transform the input direction by the camera's orientation
		var world_direction = (camera_right * direction.x) + (camera_forward * direction.z)

		# Apply the force
		apply_central_force(world_direction * speed)
	if Input.is_key_pressed(KEY_SPACE) and get_contact_count() != 0:
		apply_central_force(jump_direction * jump_strength)

	## Apply directional force
	#if direction != Vector3.ZERO:
		##var transformed_direction = transform.basis * direction
		##apply_central_force(transformed_direction * speed)
		#apply_central_force(direction * speed)
#
	## Handle jumping
	##if Input.is_action_just_pressed("jump") and is_on_floor():
		##apply_impulse(Vector3.ZERO, Vector3.UP * jump_strength)
