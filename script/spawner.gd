## FpSpawn.gd
##
## Spawns instances of a scene(s) in a defined distribution pattern
## relative to the position of this node (its parent).
@tool
extends Node3D
class_name FpSpawn

## --- Properties ---
@export var radius: float = 10.0
@export var count: int = 10
@export var spawn_in_editor: bool = false
@export var randomize_distribution: bool = true

## Single scene to spawn (drag a .tscn here)
@export var spawn_scene: PackedScene

## Array of scenes to spawn
@export var spawn_scenes: Array[PackedScene] = []

## Spawn selection mode
enum SpawnMode { SEQUENTIAL, RANDOM }
@export var spawn_mode: SpawnMode = SpawnMode.RANDOM

## Affects how we distribute the objects in 3D
enum DistributionType { SPHERICAL, TOROIDAL, ORBITAL }
@export var distribution: DistributionType = DistributionType.SPHERICAL

## For SEQUENTIAL mode, internal index
var _index := 0


func _ready():
	if Engine.is_editor_hint() and not spawn_in_editor:
		return
	_spawn_all()



func _spawn_all():
	if spawn_scene == null and spawn_scenes.is_empty():
		push_warning("FpSpawn: No spawn scene(s) assigned.")
		return

	for i in count:
		var instance = _get_next_scene_instance()
		if instance == null:
			continue
		
		# Add the instance as a child of this node (FpSpawn)
		add_child(instance)
		
		# FIX: Set the local transform origin (relative to parent)
		# The position returned by _get_spawn_position is now an offset 
		# from the spawner's origin.
		instance.transform.origin = _get_spawn_position(i)



func _get_next_scene_instance() -> Node3D:
	var scene_to_use: PackedScene = null
	match spawn_mode:
		SpawnMode.SEQUENTIAL:
			if not spawn_scenes.is_empty():
				scene_to_use = spawn_scenes[_index % spawn_scenes.size()]
				_index += 1
			else:
				scene_to_use = spawn_scene
		SpawnMode.RANDOM:
			if not spawn_scenes.is_empty():
				scene_to_use = spawn_scenes[randi() % spawn_scenes.size()]
			else:
				scene_to_use = spawn_scene

	if scene_to_use == null:
		return null

	return scene_to_use.instantiate() as Node3D



func _get_spawn_position(i: int) -> Vector3:
	match distribution:
		DistributionType.SPHERICAL:
			return _random_point_on_sphere(radius)
		DistributionType.TOROIDAL:
			return _random_point_on_torus(radius, radius * 0.3)
		DistributionType.ORBITAL:
			return _quantum_orbit_position(i)
	return Vector3.ZERO



## --- Distributions ---
## These functions already return a Vector3 offset, which is perfect 
## for setting a child's local position.

func _random_point_on_sphere(r: float) -> Vector3:
	var theta = randf_range(0, TAU)
	var phi = randf_range(0, PI)
	var x = r * sin(phi) * cos(theta)
	var y = r * sin(phi) * sin(theta)
	var z = r * cos(phi)
	return Vector3(x, y, z)

func _random_point_on_torus(major_r: float, minor_r: float) -> Vector3:
	var theta = randf_range(0, TAU)
	var phi = randf_range(0, TAU)
	var x = (major_r + minor_r * cos(phi)) * cos(theta)
	var y = (major_r + minor_r * cos(phi)) * sin(theta)
	var z = minor_r * sin(phi)
	return Vector3(x, y, z)

func _quantum_orbit_position(i: int) -> Vector3:
	# Heuristic "quantum orbital" pattern: waves of energy shells and angular nodes
	var n = float(i + 1)
	var theta = randf_range(0, TAU)
	var phi = randf_range(0, PI)
	var radial = radius * (0.5 + 0.5 * sin(n * phi + randf_range(0, TAU)))
	var x = radial * sin(phi) * cos(theta)
	var y = radial * sin(phi) * sin(theta)
	var z = radial * cos(phi)
	return Vector3(x, y, z)
