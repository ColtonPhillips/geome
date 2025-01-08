extends Node3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _process(delta: float) -> void:
	mesh_instance_3d.rotate_object_local(Vector3.UP, delta);
