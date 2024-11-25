extends Node3D
@onready var camera_3d: Camera3D = $Camera3D
@onready var character_body_3d: CharacterBody3D = $CharacterBody3D

func _process(delta):
	if camera_3d:
		camera_3d.look_at(character_body_3d.global_transform.origin, Vector3.UP)
