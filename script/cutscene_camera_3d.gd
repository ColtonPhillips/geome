extends Camera3D

# Array storing translation (position) and Euler angles (rotation)
@export var positions : Array[Vector3] = []
@export var rotations : Array[Vector3] = []  # Rotation data in Euler angles (degrees)

var current_index : int = 0  # Track the current index in the tweening sequence

func _ready():
	var target_position = positions[current_index]
	var target_rotation_euler = rotations[current_index]
	
	# Convert degrees to radians for the rotation
	var target_rotation_radians = Vector3(
		deg_to_rad(target_rotation_euler.x), 
		deg_to_rad(target_rotation_euler.y), 
		deg_to_rad(target_rotation_euler.z)
	)
	
	# Convert the Euler rotation (in radians) to a Basis
	var target_basis = Basis.from_euler(target_rotation_radians)
	
	# Create the final transform by combining position and rotation
	transform = Transform3D(target_basis, target_position)

	# Start the tweening coroutine
	if positions.size() > 0 and rotations.size() > 0:
		# Start tweening through the positions and rotations
		_animate_camera()

# Coroutine to animate the camera through all positions and rotations
func _animate_camera():
	var duration = 1
	while current_index < positions.size():
		# Get the current position and rotation for tweening
		var target_position = positions[current_index]
		var target_rotation_euler = rotations[current_index]
		
		# Convert degrees to radians for the rotation
		var target_rotation_radians = Vector3(
			deg_to_rad(target_rotation_euler.x), 
			deg_to_rad(target_rotation_euler.y), 
			deg_to_rad(target_rotation_euler.z)
		)
		
		# Convert the Euler rotation (in radians) to a Basis
		var target_basis = Basis.from_euler(target_rotation_radians)
		
		# Create the final transform by combining position and rotation
		var target_transform = Transform3D(target_basis, target_position)
		
		# Tween the camera's transform to the new position and rotation
		var tween = create_tween()
		tween.tween_property(self, "transform", target_transform, duration)
		
		# Wait for this tween to complete before moving to the next one
		await tween.finished
		await get_tree().create_timer(1.3).timeout
		duration = 5

		# Move to the next index
		current_index += 1
