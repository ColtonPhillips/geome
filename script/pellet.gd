extends Node3D

# Enum to define movement directions
enum MoveDirection {
	X,
	Z,
	Y,
}

# Export variable to set direction in the editor
@export var direction: MoveDirection = MoveDirection.X

# Movement speed of the pellet
@export var speed: float = 0.008

# https://docs.godotengine.org/en/stable/tutorials/3d/introduction_to_3d.html#coordinate-system
# Here we are getting to know the coordinate system. The below code will push the X/Y/Z in a positive direction.
# Positive X = RIGHT
# Positive Z = BACK (toward the camera, when looking at the default setting of the editor)
# Positive Y = UP

func _process(delta: float) -> void:
	# Move pellet based on the selected direction
	match direction:
		MoveDirection.X:
			global_translate(Vector3.RIGHT * speed)
			rotate(Vector3.RIGHT.cross(Vector3.DOWN), speed)
		MoveDirection.Z:
			global_translate(Vector3.BACK * speed)
			rotate(Vector3.BACK.cross(Vector3.DOWN), speed)
		MoveDirection.Y:
			global_translate(Vector3.UP * speed)
			rotate(Vector3.UP.cross(Vector3.RIGHT), speed)
			
	print(position)
