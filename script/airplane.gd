extends Node3D

func _ready() -> void:
	start_flight_path()

# Coroutine to handle the full flight path (takeoff, descent, and landing)
func start_flight_path() -> void:
	await takeoff(global_position)
	await descent(global_position)
	await landing(global_position)
	print("Landed!")

# Takeoff phase: Moves forward and slightly upward
func takeoff(initial_position: Vector3) -> void:
	var target_x := 5.0    # Horizontal target for forward movement
	var target_y := 1.0    # Vertical target for ascent
	var takeoff_duration := 2.0
	await move_smooth(initial_position.x, initial_position.x + target_x, 
					  initial_position.y, initial_position.y + target_y, 
					  takeoff_duration, 2)

# Descent phase: Moves forward faster, descending in Y
func descent(initial_position: Vector3) -> void:
	var glide_distance := 4.0  # Glide distance
	var descent_duration := 1.5
	await move_smooth(initial_position.x, initial_position.x + glide_distance, 
					  initial_position.y, initial_position.y - 4, 
					  descent_duration, 2.5)

# Landing phase: Slows down forward motion and gradually descends to final Y position
func landing(initial_position: Vector3) -> void:
	var landing_duration := 1.5
	var landing_distance := 6.0  # Landing distance
	await move_smooth(initial_position.x, 
					  initial_position.x + landing_distance, 
					  initial_position.y, initial_position.y - 1, 
					  landing_duration, 3)

# Smooth movement function to interpolate both X and Y positions, and rotate angle based on direction
func move_smooth(start_x: float, end_x: float, start_y: float, end_y: float, duration: float, easing: float = 2) -> void:
	var elapsed := 0.0
	while elapsed < duration:
		elapsed += get_process_delta_time()
		var t := elapsed / duration
		t = t ** easing  # Apply easing to slow down towards the end
		var last_position = global_position
		global_position.x = lerp(start_x, end_x, t)
		global_position.y = lerp(start_y, end_y, t)
		var direction = global_position - last_position
		var angle_radians = atan2(direction.y, direction.x)
		rotation.z = angle_radians
		await get_tree().process_frame  # Wait until the next frame
