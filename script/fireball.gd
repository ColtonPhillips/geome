extends Node3D

enum MotionType {
	SUN,       # Regular orbit in a circular path
	ELECTRON   # Chaotic, electron-like orbit
}

# Expose configuration options in the editor
@export var motion_type = MotionType.SUN
@export var rotation_speed: float = 1.0 # Speed of the rotation
@export var orbit_distance: float = 10.0 # Distance from the origin point
@export var eccentricity: float = 0.5 # Eccentricity factor for electron orbit (0 = circle, 1 = line)
@export var chaos_intensity: float = 0.2 # Chaos intensity for electron orbit

# Internal rotation angle and chaos variables
var angle: float = 0.0
var random_offset: float = 0.0

func _ready():
	# Initialize random offset for chaotic motion
	random_offset = randf() * TAU

func _process(delta):
	angle += rotation_speed * delta # Increment angle over time

	match motion_type:
		MotionType.SUN:
			orbit_like_sun()
		MotionType.ELECTRON:
			orbit_like_electron(delta)

# Orbit in a perfect circular path (like the sun)
func orbit_like_sun():
	var x = cos(angle) * orbit_distance
	var z = sin(angle) * orbit_distance
	global_transform.origin = Vector3(x, 0, z) # Adjust Y as needed

# Chaotic, elliptical orbit with random oscillations (like an electron)
func orbit_like_electron(delta):
	# Calculate a base elliptical orbit path
	var x = cos(angle) * orbit_distance * (1.0 - eccentricity)
	var z = sin(angle) * orbit_distance
	
	# Add chaos with a random offset and oscillation for X and Z directions
	x += sin(angle * 2.0 + random_offset) * orbit_distance * chaos_intensity
	z += cos(angle * 1.5 + random_offset) * orbit_distance * chaos_intensity

	# Add a vertical oscillation to make the orbit appear more 3D and chaotic
	var y = sin(angle * 3.0 + random_offset) * orbit_distance * chaos_intensity

	global_transform.origin = Vector3(x, y, z)
