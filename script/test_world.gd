extends Node3D

@onready var text_mesh_3d: MeshInstance3D = $TextMesh3D
@onready var initial_position = text_mesh_3d.global_transform.origin
@onready var flashlight: Node3D = $Flashlight

enum AnimationDemo {
	X,
	Z,
	Y,
	BOUNCE
}

# Rotate the flashlight by a given angle (in degrees) around the Y-axis
func rotate_flashlight(degrees: float) -> void:
	var radians = deg_to_rad(degrees)
	# Get the current transform of the flashlight
	var transform = flashlight.transform
	# Rotate the basis of the transform
	transform.basis = transform.basis.rotated(Vector3.UP, radians)
	transform.basis = transform.basis.rotated(Vector3.LEFT, 0.25 * radians)
	transform.basis = transform.basis.rotated(Vector3.BACK, 1.5 * radians)
	# Apply the modified transform back to the flashlight
	flashlight.transform = transform

@export var direction: AnimationDemo = AnimationDemo.X
@export var speed: float = 0.008
@export var rotation_amplitude: float = 0.05  # Controls rotation intensity

var elapsed_time = 0.0
@export var bounce_frequency := 6  # Frequency of the bounces
@export var switch_time = 1.0  # Time interval for random direction change
var time_since_switch = 0.0

# Calculate Y position for bounce effect
func get_y_position(delta: float) -> float:
	elapsed_time += delta
	bounce_frequency += delta
	var initial_height := 6.0  # Starting height in units
	var damping := 0.8  # Damping factor
	return initial_height * exp(-damping * elapsed_time) * abs(sin(bounce_frequency * elapsed_time))

# Randomly switch to a new direction if not in BOUNCE mode
func randomize_direction() -> void:
	var new_direction = direction
	while new_direction == direction:
		new_direction = randi_range(0, AnimationDemo.size() - 1)  # Random X, Y, or Z
	direction = new_direction

# Rotation functions for each axis
func rotate_x_demo(delta: float) -> void:
	text_mesh_3d.rotation.x = sin(elapsed_time * speed) * rotation_amplitude

func rotate_y_demo(delta: float) -> void:
	text_mesh_3d.rotation.y = sin(elapsed_time * speed) * rotation_amplitude

func rotate_z_demo(delta: float) -> void:
	text_mesh_3d.rotation.z = sin(elapsed_time * speed) * rotation_amplitude

# Bounce function
func bounce(delta: float) -> void:
	text_mesh_3d.global_transform.origin.y = get_y_position(delta) + initial_position.y

# Main process function
func _process(delta: float) -> void:
	rotate_flashlight(delta* 10)
	
	elapsed_time += delta
	time_since_switch += delta

	# Switch direction every second for X, Y, or Z
	if time_since_switch >= switch_time:
		randomize_direction()
		time_since_switch = 0.0

	# Apply animation based on direction
	match direction:
		AnimationDemo.X:
			rotate_x_demo(delta)
		AnimationDemo.Y:
			rotate_y_demo(delta)
		AnimationDemo.Z:
			rotate_z_demo(delta)
		AnimationDemo.BOUNCE:
			bounce(delta)
