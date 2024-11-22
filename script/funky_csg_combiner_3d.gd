extends CSGCombiner3D
@export var _n: Node3D

@onready var initial_position = _n.position	

func _ready() -> void:
	await_move_shape()
func await_move_shape() -> void:
	while true:
		_n.position = initial_position  + Vector3.ONE * 2 * sin(0.00005 * Time.get_ticks_msec())
		await get_tree().process_frame
