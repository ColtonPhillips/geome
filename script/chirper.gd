extends Node3D

@onready var path: Path3D = $Path3D
@onready var follower: PathFollow3D = $Path3D/PathFollow3D
@onready var audio: AudioStreamPlayer3D = $Path3D/PathFollow3D/AudioStreamPlayer3D

@export var move_duration: float = 5.0
@export var play_on_start: bool = true
@export var speed_scale: float = 1.0 # runtime multiplier

var speed: float
var is_moving: bool = false

func _ready():
	follower.progress_ratio = 0.0

	# speed = fraction of the curve per second
	speed = 1.0 / move_duration

	if play_on_start:
		start_motion()


func start_motion():
	if is_moving:
		return
	is_moving = true
	audio.play()


func _process(delta: float):
	if not is_moving:
		return

	# fmod() allows float modulus (wraps around 0–1.0 smoothly)
	follower.progress_ratio = fmod(
		follower.progress_ratio + (speed * speed_scale * delta),
		1.0
	)
