extends RigidBody3D  # Change to Node2D if you're working in 2D

@export var child_scene: PackedScene = preload("res://scene/soap_bubble.tscn")

func _ready():
	# Start the timer loop
	_schedule_next_spawn()

var wait_your_time = 0
func _schedule_next_spawn():
	var random_time = randf_range(0.3, 2.7)  # Random time between 1 and 100 seconds
	await get_tree().create_timer(random_time).timeout
	_spawn_child()
	wait_your_time += 1
	if wait_your_time < 10:
		_schedule_next_spawn()  # Schedule the next spawn

func _spawn_child():
	var child_instance: RigidBody3D = child_scene.instantiate()
	child_instance.global_transform = self.global_transform  # Match position and rotation
	
	# Move the child instance in a random direction
	var random_direction = Vector3(randf_range(-1.0, 1.0), randf_range(1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	var move_distance = randf_range(1.0, 2.1)  # Random distance to move
	child_instance.translate(random_direction * move_distance)
	
	get_parent().add_child(child_instance)
