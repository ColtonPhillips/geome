extends RigidBody3D

# Adjustable properties for gameplay tweaking
@export var camera: Camera3D

# Physics material for the marble
func _ready():
	pass

var jump_direction := Vector3(0,0,0)
# XXX: maybe buggy to run on frames not delta but big woop
var jump_buffer_size := 15
var jump_buffer_timer = 0
var should_activate_buffered_jump := false

var coyote_buffer_size := 15
var coyote_timer = 0
func _integrate_forces(state: PhysicsDirectBodyState3D):
	var normal_temp = Vector3()
	for i in range(state.get_contact_count()):
		var body = state.get_contact_collider_object(i)  # Get the colliding body
		var normal = state.get_contact_local_normal(i)  # Get the normal
		normal_temp += normal
	if state.get_contact_count() != 0:
		normal_temp /= state.get_contact_count()
		jump_direction = normal_temp.normalized()
		coyote_timer = coyote_buffer_size 
		if jump_buffer_timer > 0 and not should_activate_buffered_jump:
			should_activate_buffered_jump = true
			 
	if coyote_timer > 0:
		coyote_timer -= 1
		
	if jump_buffer_timer > 0:
		jump_buffer_timer -= 1
	if jump_buffer_timer <= 0:
		should_activate_buffered_jump = false

@export var jump_strength: float = 1200.0  # Strength of the jump
@export var speed: float = 30.0  # Speed multiplier for player input
var jump_mutex := false
func _physics_process(delta):
	# Get player input for movement
	var direction := Vector3.ZERO
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

	# Apply directional force relative to the camera
	if direction != Vector3.ZERO and camera:
		# Get the camera's forward and right vectors
		var camera_forward = camera.global_transform.basis.z.normalized()
		var camera_right = camera.global_transform.basis.x.normalized()

		# Transform the input direction by the camera's orientation
		var world_direction = (camera_right * direction.x) + (camera_forward * direction.z)

		# Apply the force
		apply_central_force(world_direction * speed)
	
	#Kind of a lazy approach but if it works it works
	var reset_jump_mutex_later: Callable = func():
		await get_tree().create_timer(1).timeout
		jump_mutex = false

	if jump_mutex == false:
		if Input.is_action_just_pressed("ui_select"):
			should_activate_buffered_jump = false
			jump_buffer_timer = jump_buffer_size
		if Input.is_action_just_pressed("ui_select") and coyote_timer > 0 or should_activate_buffered_jump:
			if should_activate_buffered_jump:
				var velocity = linear_velocity
				# Compute the component of velocity in the direction of the jump normal
				var normal_velocity = jump_direction * velocity.dot(jump_direction)
				velocity -= normal_velocity
				set_linear_velocity(velocity)
				
			apply_central_force(jump_direction * jump_strength)
			should_activate_buffered_jump = false
			jump_buffer_timer = 0
			coyote_timer = 0
			
			jump_mutex = true
			reset_jump_mutex_later.call()
