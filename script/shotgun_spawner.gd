extends Node3D

# Path to the ShotgunPellet scene
@export var shotgun_pellet_scene: PackedScene
@export var spawn_interval: float = 1.0 # Seconds between each shot
@export var pellet_speed: float = 16.0  # Speed of the pellets
@export var short_speed: float = 10.0  # Speed of the pellets
@export var rapid_interval: float = 0.2
@export var temp_interval: float = 1
func _ready():
	temp_interval = spawn_interval
	shoot_pellet_loop()

func shoot_pellet_loop():
	while true:
		await get_tree().create_timer(spawn_interval).timeout
		_spawn_shotgun_pellet()

func _spawn_shotgun_pellet():
	if shotgun_pellet_scene == null:
		return # Ensure the scene is assigned

	# Instance the ShotgunPellet scene
	var pellet: Node3D = shotgun_pellet_scene.instantiate()

	# Set the pellet's initial position and rotation
	var spawn_transform = global_transform
	spawn_transform.origin += spawn_transform.basis.y * -0.5
	spawn_transform.origin += spawn_transform.basis.x * +0.5
	pellet.global_transform = spawn_transform
	

	# Add the pellet to the scene tree
	get_tree().root.add_child(pellet)

	# Apply velocity to the pellet
	var forward_direction = global_transform.basis.z.normalized() * -1
	spawn_interval = temp_interval
	if Input.is_key_pressed(KEY_CTRL):
		pellet.apply_central_impulse(forward_direction * pellet_speed)
	else:
		pellet.apply_central_impulse(forward_direction * short_speed)

	if Input.is_key_pressed(KEY_ALT):
		spawn_interval = rapid_interval
