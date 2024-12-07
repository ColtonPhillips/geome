extends Node3D
@onready var csg_cup_animatable_body_3d: AnimatableBody3D = $CSGCupAnimatableBody3D


# Rotation speed in degrees per second
@export var rotation_speed: float = 5.0  # Adjust as needed

func _physics_process(delta: float) -> void:
	# Rotate locally around the Y-axis (upward in local space) based on delta
	csg_cup_animatable_body_3d.rotate_object_local(Vector3.UP, rotation_speed * delta)
	pass
