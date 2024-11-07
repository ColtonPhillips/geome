extends Node3D

# Enum to define movement directions
enum MoveDirection {
	X,
	Y,
	Z
}

# Export variable to set direction in the editor
@export var direction: MoveDirection = MoveDirection.X

# Movement speed of the pellet
@export var speed: float = 0.01

func _process(delta: float) -> void:
	# Move pellet based on the selected direction
	match direction:
		MoveDirection.X:
			translate_object_local(Vector3.RIGHT * speed)
		MoveDirection.Y:
			translate_object_local(Vector3.FORWARD * speed)
		MoveDirection.Z:
			translate_object_local(Vector3.UP * speed)
