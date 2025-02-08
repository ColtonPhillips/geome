extends Node3D
@onready var camera_3d: Camera3D = $Camera3D
@onready var marble_body_3d: RigidBody3D = $MarbleBody3D

func _process(delta: float) -> void:
	camera_3d.look_at(marble_body_3d.position)
	$DemoButtonCanvasLayer/APressed.visible = Input.is_action_pressed("ui_select")
	$DemoButtonCanvasLayer/AUnpressed.visible = not Input.is_action_pressed("ui_select")
