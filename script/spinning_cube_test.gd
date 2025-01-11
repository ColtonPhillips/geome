extends Node3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@export var rotate_speed = 0.5;
@export var rotate_time = 11.1;
@export var rotate_direction = 1.0;

func _ready() -> void:
	await_change_direction()
	
func await_change_direction() -> void:
	while true:
		await get_tree().create_timer(rotate_time).timeout
		rotate_direction *= -1


func _process(delta: float) -> void:
	mesh_instance_3d.rotate_object_local(Vector3.UP, rotate_direction * rotate_speed * delta);
