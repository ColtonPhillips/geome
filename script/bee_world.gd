extends Node3D

#@export var bee_scene: PackedScene  # The PackedScene of the bee object
var bee_scene = preload("res://scene/bee.tscn")  # The PackedScene of the bee object
@export var num_bees: int = 10  # Number of bees to spawn
@export var spawn_radius: float = 300.0  # Maximum spawn radius from the world origin

func _ready():
	if bee_scene == null:
		print("Error: Bee scene is not assigned.")
		return

	for i in range(num_bees):
		spawn_bee()

func spawn_bee():
	# Instance a bee from the bee_scene
	var bee = bee_scene.instantiate()
	if bee:
		# Randomize its initial position within the spawn radius
		var random_pos = _get_random_position_within_radius(spawn_radius)
		
		# Add the bee to the current world (tree)
		add_child(bee)
		
		# Now set the position after the bee is added to the tree
		bee.global_transform.origin = random_pos
	else:
		print("Error: Failed to instance bee.")

func _get_random_position_within_radius(radius: float) -> Vector3:
	# Generate a random position within a spherical radius
	var x = randf_range(-radius, radius)
	var y = randf_range(-radius / 2, radius / 2)  # Constrain Y for a flat-ish plane
	var z = randf_range(-radius, radius)
	var random_position = Vector3(x, y, z)

	# Ensure the position is within the spherical boundary
	if random_position.length() > radius:
		return random_position.normalized() * radius
	return random_position
