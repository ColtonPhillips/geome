extends Camera3D

# --- Configurable Variables ---
@export var forward_speed: float = 10.0         # Maximum forward/backward speed (m/s)
@export var lateral_speed: float = 5.0         # Maximum strafe/vertical speed (m/s)
@export var rotation_speed: float = 2.0        # Maximum angular speed (rad/s)
@export var movement_easing: float = 4.0       # Time to reach max speed (approx 4 seconds)
@export var rotation_easing: float = 5.0       # Time to reach max angular speed
@export var linear_drag: float = 2.0           # Linear drag factor (higher = slower stop)
@export var angular_drag: float = 2.0          # Angular drag factor for smooth rotation

# --- Internal Variables ---
var target_velocity: Vector3 = Vector3.ZERO     # Desired linear velocity
var current_velocity: Vector3 = Vector3.ZERO    # Actual linear velocity
var target_rotation_velocity: Vector3 = Vector3.ZERO  # Desired angular velocity
var current_rotation_velocity: Vector3 = Vector3.ZERO  # Actual angular velocity

# --- Main Process Loop ---
func _process(delta):
	# Update movement and rotation targets based on player input
	_update_target_velocity()
	_update_target_rotation_velocity()

	# Apply linear drag to slow down naturally when no input is present
	current_velocity = current_velocity.move_toward(Vector3.ZERO, linear_drag * delta)

	# Apply angular drag for smooth rotational stop
	current_rotation_velocity = current_rotation_velocity.move_toward(Vector3.ZERO, angular_drag * delta)

	# Smoothly interpolate actual velocities towards target velocities
	current_velocity = current_velocity.lerp(target_velocity, movement_easing * delta)
	current_rotation_velocity = current_rotation_velocity.lerp(target_rotation_velocity, rotation_easing * delta)

	# Apply translation (movement) and rotation to the object
	translate(current_velocity * delta)
	rotate_object_local(Vector3(1, 0, 0), current_rotation_velocity.x * delta)  # Pitch
	rotate_object_local(Vector3(0, 1, 0), current_rotation_velocity.y * delta)  # Yaw
	rotate_object_local(Vector3(0, 0, 1), current_rotation_velocity.z * delta)  # Roll

# --- Update Target Linear Velocity ---
func _update_target_velocity():
	# Input-based movement directions
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

	# Assign direction-specific maximum speeds
	target_velocity = Vector3(
		direction.x * lateral_speed,                          # X-axis (strafe)
		direction.y * lateral_speed,                          # Y-axis (ascend/descend)
		direction.z * (forward_speed if direction.z != 0 else lateral_speed)  # Z-axis
	)

# --- Update Target Angular Velocity ---
func _update_target_rotation_velocity():
	# Input-based rotation directions
	var rotation = Vector3.ZERO

	# Rotation inputs
	if Input.is_physical_key_pressed(KEY_DOWN): rotation.x -= 1  # Pitch up
	if Input.is_physical_key_pressed(KEY_UP): rotation.x += 1  # Pitch down
	if Input.is_physical_key_pressed(KEY_RIGHT): rotation.y -= 1  # Yaw left
	if Input.is_physical_key_pressed(KEY_LEFT): rotation.y += 1  # Yaw right
	if Input.is_physical_key_pressed(KEY_Z): rotation.z += 1  # Roll left
	if Input.is_physical_key_pressed(KEY_C): rotation.z -= 1  # Roll right

	# Scale rotation input by max angular speed
	target_rotation_velocity = rotation * rotation_speed

# --- Notes for Tuning ---
# 1. Adjust `linear_drag` and `angular_drag` to control how quickly the ship slows down.
#    - Lower values will make the ship feel "floatier" (coasts for longer).
#    - Higher values will make the ship come to a stop more quickly.
# 2. Tweak `movement_easing` and `rotation_easing` to adjust how responsive the controls feel.
#    - Lower values make the controls more snappy but can feel less realistic.
#    - Higher values make transitions smoother but can feel sluggish.
# 3. Max speeds (`forward_speed` and `lateral_speed`) define how fast the ship can move in each direction.
#    - These can be tweaked to emphasize forward movement over strafing, as in many space games.
