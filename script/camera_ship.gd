extends Camera3D

# --- Configurable Variables ---
@export var forward_speed: float = 12.0         # Maximum forward/backward speed (m/s)
@export var lateral_speed: float = 8.0         # Maximum strafe/vertical speed (m/s)
@export var rotation_speed: float = 3.0        # Maximum angular speed for keyboard input (rad/s)
@export var movement_easing: float = 3.0       # Time to reach max speed (approx 4 seconds)
@export var rotation_easing: float = 5.0       # Time to reach max angular speed for keyboard input
@export var linear_drag: float = 1.0           # Linear drag factor (higher = slower stop)
@export var angular_drag: float = 1.0          # Angular drag factor for smooth keyboard rotation
@export var mouse_sensitivity: float = 0.1     # Sensitivity for mouse movement

# --- Internal Variables ---
var target_velocity: Vector3 = Vector3.ZERO     # Desired linear velocity
var current_velocity: Vector3 = Vector3.ZERO    # Actual linear velocity
var target_rotation_velocity: Vector3 = Vector3.ZERO  # Desired angular velocity
var current_rotation_velocity: Vector3 = Vector3.ZERO  # Actual angular velocity
var rotation_input: Vector2 = Vector2.ZERO      # Track mouse input for rotation (using Vector2 for easier x/y handling)
var mouse_captured: bool = true                 # Track whether the mouse is captured

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# --- Main Process Loop ---
func _physics_process(delta: float) -> void:
	# Handle mouse capture toggle
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_mouse_capture()

	# Update movement and rotation targets based on player input
	_update_target_velocity()
	_update_target_rotation_velocity(delta)

	# Apply linear drag to slow down naturally when no input is present
	current_velocity = current_velocity.move_toward(Vector3.ZERO, linear_drag * delta)

	# Apply angular drag for smooth keyboard rotation stop
	current_rotation_velocity = current_rotation_velocity.move_toward(Vector3.ZERO, angular_drag * delta)

	# Smoothly interpolate actual velocities towards target velocities
	current_velocity = current_velocity.lerp(target_velocity, movement_easing * delta)
	current_rotation_velocity = current_rotation_velocity.lerp(target_rotation_velocity, rotation_easing * delta)

	# Apply translation (movement) and keyboard rotation
	translate(current_velocity * delta)
	rotate_object_local(Vector3(0, 1, 0), current_rotation_velocity.y * delta)  # Yaw
	rotate_object_local(Vector3(1, 0, 0), current_rotation_velocity.x * delta)  # Pitch
	rotate_object_local(Vector3(0, 0, 1), current_rotation_velocity.z * delta)  # Roll

	# Apply mouse-based rotation directly for FPS-like responsiveness
	_apply_mouse_rotation(delta)

# --- Update Target Linear Velocity ---
func _update_target_velocity():
	var direction = Vector3.ZERO

	# Linear movement inputs
	if Input.is_physical_key_pressed(KEY_W): direction.z -= 1  # Forward
	if Input.is_physical_key_pressed(KEY_S): direction.z += 1  # Backward
	if Input.is_physical_key_pressed(KEY_A): direction.x -= 1  # Strafe left
	if Input.is_physical_key_pressed(KEY_D): direction.x += 1  # Strafe right
	if Input.is_physical_key_pressed(KEY_Q): direction.y += 1  # Ascend
	if Input.is_physical_key_pressed(KEY_E): direction.y -= 1  # Descend

	# Normalize direction to prevent faster diagonal movement
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	var moreward_speed = forward_speed if not Input.is_physical_key_pressed(KEY_SHIFT) else forward_speed * 8
	target_velocity = Vector3(
		direction.x * lateral_speed,
		direction.y * lateral_speed,
		direction.z * (moreward_speed if direction.z != 0 else lateral_speed)
	)

# --- Update Target Angular Velocity (Keyboard) ---
func _update_target_rotation_velocity(delta):
	var rotation = Vector3.ZERO

	# Keyboard-based rotation
	if Input.is_physical_key_pressed(KEY_DOWN): rotation.x -= 1  # Pitch up
	if Input.is_physical_key_pressed(KEY_UP): rotation.x += 1    # Pitch down
	if Input.is_physical_key_pressed(KEY_RIGHT): rotation.y -= 1  # Yaw left
	if Input.is_physical_key_pressed(KEY_LEFT): rotation.y += 1   # Yaw right
	if Input.is_physical_key_pressed(KEY_Z): rotation.z += 1      # Roll left
	if Input.is_physical_key_pressed(KEY_C): rotation.z -= 1      # Roll right

	target_rotation_velocity = rotation * rotation_speed

func _apply_mouse_rotation(delta: float) -> void:
	if mouse_captured:
		# Only apply mouse input to yaw (left-right) and pitch (up-down), not roll.
		if rotation_input.length() > 0:
			# Apply mouse rotation to pitch (X) and yaw (Y)
			rotate_object_local(Vector3(1, 0, 0), rotation_input.y * delta)  # Pitch (mouse)
			rotate_y(rotation_input.x * delta)
			#rotate_object_local(Vector3(0, 1, 0), rotation_input.x * delta)  # Yaw (mouse)
			

			# Reset rotation input to avoid accumulation.
			rotation_input.x = 0
			rotation_input.y = 0


# --- Mouse Capture Toggle ---
func _toggle_mouse_capture():
	mouse_captured = not mouse_captured
	if mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# --- Input Event ---
func _input(event: InputEvent) -> void:
	# Handle mouse input for camera rotation
	if event is InputEventMouseMotion and mouse_captured:
		var mouse_delta = event.relative * mouse_sensitivity
		rotation_input.x = -mouse_delta.x  # Yaw (left/right)
		rotation_input.y = -mouse_delta.y  # Pitch (up/down)
