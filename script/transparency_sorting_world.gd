extends Node3D

@onready var capsule: MeshInstance3D = $Capsule
@onready var prism: MeshInstance3D = $Prism

# Amplitudes and frequencies for movement
var amplitude_y: float = 0.7  # Height oscillation for capsule
var amplitude_z: float = 0.5  # Depth oscillation for prism
var frequency: float = 1.0    # Oscillation speed
var frequency_2: float = 1.1    # Oscillation speed
var time: float = 0.0

func _process(delta: float) -> void:
	time += delta
	
	# Move capsule up and down (Y-axis sinusoidal motion)
	capsule.transform.origin.y = amplitude_y * sin(time * frequency)
	
	# Move prism back and forth along the Z-axis
	prism.transform.origin.z = amplitude_z * sin(time * frequency_2)
