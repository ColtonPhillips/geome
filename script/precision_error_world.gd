extends Node3D
@onready var axis_node_3d: Node3D = $AxisNode3D
@onready var label_3d: Label3D = $Label3D

# Number of iterations to simulate
var iterations = 200000
var scale_frequency = 0.1  # Frequency of the sinusoidal scaling
var scale_amplitude = 0.1  # Maximum deviation from 1.0
var rotate_speed = 0.000005
# Accumulator for the transform operations
var transform_accumulator = Transform3D()

func _ready():
	# Start with the current transform
	transform_accumulator = axis_node_3d.transform

	# Simulate precision errors
	apply_repeated_transformations()

	# Debug print to check the final state
	print("Final Transform: ", transform)

func apply_repeated_transformations():
	check_orthonormality()
	for i in range(iterations):
		# Apply a small rotation (introducing error over time)
		var rotation_delta = Basis()
		rotation_delta = rotation_delta.rotated(Vector3(0, 1, 0), deg_to_rad(rotate_speed)) # Yaw slightly
		transform_accumulator.basis *= rotation_delta
		
		rotation_delta = rotation_delta.rotated(Vector3(1, 0, 0), deg_to_rad(rotate_speed)) # Yaw slightly
		transform_accumulator.basis *= rotation_delta
				
		#rotation_delta = rotation_delta.rotated(Vector3(0, 0, 1), deg_to_rad(rotate_speed)) # Yaw slightly
		#transform_accumulator.basis *= rotation_delta
		
		# Apply a small random scaling effect
		var r = randf_range(0.99999, 1.00001)
		var random_scale = Vector3(
			r,  # X-axis random scale
			r,  # Y-axis random scale
			r   # Z-axis random scale
		)
		transform_accumulator = transform_accumulator.scaled(random_scale)

		# Update the current transform
		axis_node_3d.transform = transform_accumulator


func _process(delta: float) -> void:
	apply_repeated_transformations()


func check_orthonormality():
	var basis = axis_node_3d.transform.basis
	var tolerance = 1e-6  # Small threshold for floating-point errors

	# Check if the columns of the basis are orthogonal
	var dot_xy = basis.x.dot(basis.y)
	var dot_xz = basis.x.dot(basis.z)
	var dot_yz = basis.y.dot(basis.z)
	var length_x = basis.x.length()
	var length_y = basis.y.length()
	var length_z = basis.z.length()
	var v = "\n"
	# Check if the vectors are orthogonal and normalized (with a tolerance)
	if abs(dot_xy) < tolerance and abs(dot_xz) < tolerance and abs(dot_yz) < tolerance:
		v+="The basis vectors are orthogonal.\n"
	else:
		v+="The basis vectors are NOT orthogonal.\n"
		
	if abs(length_x - 1.0) < tolerance and abs(length_y - 1.0) < tolerance and abs(length_z - 1.0) < tolerance:
		v+="The basis vectors are normalized.\n"
	else:
		v+="The basis vectors are NOT normalized.\n"
		
	
	var s = ""
	s += "
Dot product (x,y): {}
Dot product (x,z): {}
Dot product (y,z): {}

Length (x): {}
Length (y): {}
Length (z): {}
".format([  dot_xy, dot_xz, dot_yz,
			length_x, length_y, length_z
			], "{}")

		
	label_3d.text = s + v
