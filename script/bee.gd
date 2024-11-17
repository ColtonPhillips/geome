extends Node3D

# Orbital and sinusoidal movement variables
@export var speed = 0.01  # Orbital speed
@export var sinusoidal_offset = 1.0  # Amplitude of the sinusoidal effect
@export var radius_range = Vector2(100.0, 1000.0)  # Min and max radius
@export var angle_range = Vector2(0, 360)  # Min and max angle in degrees

var current_radius = 0.0  # Current orbit radius
var current_angle = 0.0  # Current angle in radians
var time_offset = 0.0  # Time offset for sinusoidal motion

# Audio variables
var playback  # Will hold the AudioStreamGeneratorPlayback
@onready var sample_hz = $AudioStreamPlayer3D.stream.mix_rate  # Audio sample rate
var pulse_hz = 220.0  # Base frequency of the buzzing sound

func _ready():
	# Setup the AudioStreamPlayer3D
	randomize()
	$AudioStreamPlayer3D.play()
	call_deferred("_initialize_playback")  # Ensure playback is accessed after initialization

	# Randomize orbital position
	current_radius = randf_range(radius_range.x, radius_range.y)
	current_angle = deg_to_rad(randf_range(angle_range.x, angle_range.y))
	time_offset = randi() % 1000  # Random time offset for sinusoidal motion

func _initialize_playback():
	# Access the playback after ensuring the player is active
	playback = $AudioStreamPlayer3D.get_stream_playback()
	if playback:
		fill_buffer()
	else:
		print("Error: Playback could not be initialized.")

func fill_buffer():
	var phase = 0.0
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()

	for i in range(frames_available):
		# Generate a basic buzzing sound with some randomness
		var noise = randf_range(-0.05, 0.05)  # Add slight randomness to the wave
		playback.push_frame(Vector2.ONE * (sin(phase * TAU) + noise))
		phase = fmod(phase + increment, 1.0)

func _process(delta):
	# Update the angle based on speed
	current_angle += speed * delta
	if current_angle > TAU:
		current_angle -= TAU  # Keep angle in [0, 2π]

	# Calculate position
	var x = current_radius * cos(current_angle)
	var z = current_radius * sin(current_angle)
	var y = sinusoidal_offset * sin(time_offset + current_angle * 2.0)  # Vertical bobbing

	# Update position
	global_transform.origin = Vector3(x, y, z)

	# Continuously fill the audio buffer
	if playback:
		fill_buffer()
