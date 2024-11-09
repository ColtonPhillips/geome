extends Node3D

# Enum to define movement directions
enum AnimationDemo {
	X,
	Z,
	Y,
	BOUNCE
}

@onready var initial_position = position

@export var direction: AnimationDemo = AnimationDemo.X
@export var speed: float = 0.008


var elapsed_time = 0.0
var frequency := 6  # Frequency of the bounces
func get_y_position(delta: float) -> float:
	elapsed_time += delta
	frequency += delta
	var initial_height := 6.0  # Starting height in pixels or units
	var damping := 0.8  # Damping factor to reduce height over time (try values between 0.2 and 0.8)
	return initial_height * exp(-damping * elapsed_time) * abs(sin(frequency * elapsed_time))

# https://docs.godotengine.org/en/stable/tutorials/3d/introduction_to_3d.html#coordinate-system
# Here we are getting to know the coordinate system. The below code will push the X/Y/Z in a positive direction.
# Positive X = RIGHT
# Positive Z = BACK (toward the camera, when looking at the default setting of the editor)
# Positive Y = UP
func _process(delta: float) -> void:
	# Move pellet based on the selected direction
	match direction:
		AnimationDemo.X:
			global_translate(Vector3.RIGHT * speed)
			rotate(Vector3.RIGHT.cross(Vector3.DOWN), speed)
		AnimationDemo.Z:
			global_translate(Vector3.BACK * speed)
			rotate(Vector3.BACK.cross(Vector3.DOWN), speed)
		AnimationDemo.Y:
			global_translate(Vector3.UP * speed)
			rotate(Vector3.UP.cross(Vector3.RIGHT), speed)
		AnimationDemo.BOUNCE:
			global_translate(Vector3.RIGHT * 0.6 * speed)
			rotate(Vector3.RIGHT.cross(Vector3.DOWN), 0.6 * speed)
			global_position.y = get_y_position(delta) + initial_position.y
