extends AudioStreamPlayer3D

@export var min_range: Vector3 = Vector3(-10, -10, -10)  # Minimum bounds for random position
@export var max_range: Vector3 = Vector3(10, 10, 10)    # Maximum bounds for random position
@export var play_interval: float = 1.0                 # Time between plays
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var _timer: float = 0.0

func _ready():
	_randomize_position()
	play()  # Play the first sound immediately

func _process(delta: float):
	mesh_instance_3d.scale = mesh_instance_3d.scale * randf_range(0.99,1.01)
	_timer += delta
	if _timer >= play_interval:
		_timer = 0.0
		_randomize_position()
		_play_random_sfx()

func _play_random_sfx():
	play()

func _randomize_position():
	var new_position = Vector3(
		randf_range(min_range.x, max_range.x),
		randf_range(min_range.y, max_range.y),
		randf_range(min_range.z, max_range.z)
	)
	global_transform.origin = new_position
