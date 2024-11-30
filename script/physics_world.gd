extends Node3D

@onready var camera_3d: Camera3D = $Camera3D

# Preload the object to spawn
var object_scene = preload("res://scene/popcorn_ball.tscn")

# Timer variables
var timer = 0.0
var spawn_interval = 0.15
func expand_view(camera: Camera3D, distance: float):
	# Move the camera backwards along its local Z-axis
	var backward = camera.transform.basis.z.normalized() # Positive Z direction
	camera.transform.origin += backward * distance
	
func _process(delta):
	expand_view(camera_3d, 0.85 * delta)
	
	# Update the timer
	timer += delta
	# Check if the interval has passed
	if timer >= spawn_interval:
		# Reset the timer
		timer = 0.0
		# Spawn the object	
		var new_object = object_scene.instantiate()
		add_child(new_object)
		# Set position or transform as needed
		new_object.position = Vector3(randf_range(-10,10), 40, randf_range(-10,10))
		
		spawn_interval-= 0.001
