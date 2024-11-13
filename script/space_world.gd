extends Node3D

@export var rotation_speed: float = 1.0 # Speed of rotation
@export var orbit_distance: float = 10.0 # Distance from the origin

@onready var camera_3d: Camera3D = $Camera3D

var angle: float = 0.0 # Rotation angle in radians

func _process(delta):
	# Increment the rotation angle based on the rotation speed
	angle += rotation_speed * delta

	# Calculate the new position of the camera in spherical coordinates
	var x = cos(angle) * orbit_distance
	var z = sin(angle) * orbit_distance
	var y = 1.5 * sin(angle) # Adjust Y if you want the camera to move vertically as well

	# Update the camera position
	camera_3d.global_transform.origin = Vector3(x, y, z)
	
	# Make the camera look at the origin (0, 0, 0)
	camera_3d.look_at(Vector3(0, 0, 0))
