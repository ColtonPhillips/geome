extends Node3D
class_name MarbleCamera3DContainer

@export var marble_body_3d: MarbleBody3D
@onready var h_rotation: Node3D = $HRotation
@onready var v_rotation: Node3D = $HRotation/VRotation

@export var cam_v_max : float = 110.0
@export var cam_v_min : float = -75.0
var camera_rotation_horizontal : float = 0.0
var camera_rotation_vertical : float = 0.0
@export var h_sensitivity : float = 0.1
@export var v_sensitivity : float = 0.1
@export var h_acceleration : float = 15.0
@export var v_acceleration : float = 15.0
@export var smooth_camera_tolerance : float = .3
@onready var camera_3d: Camera3D = $HRotation/VRotation/SpringArm3D/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_mouse_capture()

func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, marble_body_3d.global_position,smooth_camera_tolerance)
	camera_rotation_vertical = clamp(camera_rotation_vertical, cam_v_min, cam_v_max)
	h_rotation.rotation_degrees.y = lerp(h_rotation.rotation_degrees.y, camera_rotation_horizontal, delta * h_acceleration)
	v_rotation.rotation_degrees.x = lerp(v_rotation.rotation_degrees.x, camera_rotation_vertical, delta * v_acceleration)
	rotation_degrees.z = 0

# --- Mouse Capture Toggle ---
var mouse_captured := true
func _toggle_mouse_capture():
	mouse_captured = not mouse_captured
	if mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseMotion:
		camera_rotation_horizontal += -event.relative.x * h_sensitivity
		camera_rotation_vertical += -event.relative.y * v_sensitivity
