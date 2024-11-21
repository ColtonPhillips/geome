extends Node3D

# Preload the object to spawn
var object_scene = preload("res://scene/popcorn_ball.tscn")

# Timer variables
var timer = 0.0
@export var spawn_interval = 0.02
@export var spawn_radius: float = 300.0  # Maximum spawn radius from the world origin
@export var spawn_height = 10
func _process(delta: float) -> void:
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
		new_object.position = Vector3(randf_range(-spawn_radius,spawn_radius), spawn_height, randf_range(-spawn_radius,spawn_radius))
