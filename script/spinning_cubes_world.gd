extends Node3D
@onready var cube_container: Node3D = $CubeContainer
@onready var cube_columns = 32
@onready var cube_rows = 32

@onready var pad_width = 6
@onready var pad_height = 3.8
var cube_scene = preload("res://scene/spinning_cube_test.tscn")

func _ready() -> void:
	add_cubes_to_the_scene()

func add_cubes_to_the_scene() -> void:
	var noise_map = FastNoiseLite.new()
	noise_map.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_map.frequency = 1
	
	var spawn_transform = global_transform
	#spawn_transform.position.x -= pad_width * (cube_columns / 2)
	#spawn_transform.position.y -= pad_height * (cube_rows / 2)
	spawn_transform = spawn_transform.translated(Vector3(-pad_width * (cube_columns / 2), -pad_height * (cube_rows / 2), 0))
	for w in range(cube_columns):
		for h in range(cube_rows):
			var instance: Node3D = cube_scene.instantiate()
			cube_container.add_child(instance)
			instance.global_transform = spawn_transform
			instance.transform = instance.transform.translated(Vector3(pad_width * w,pad_height * h,0))
			var x = noise_map.get_noise_2d(instance.global_position.x, instance.global_position.y)
			instance.rotate_time += x/ 10.0
			instance.rotate_speed += w / 128.0
			instance.rotate_speed += h / 256.0
