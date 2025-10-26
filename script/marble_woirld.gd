extends Node3D
class_name MarbleWorld
@onready var marble_body_3d: RigidBody3D = $MarbleBody3D
@onready var marble_camera_3d_container: MarbleCamera3DContainer = $MarbleCamera3DContainer

func _process(_delta: float) -> void:
	marble_camera_3d_container.camera_3d.look_at(marble_body_3d.position)
	$DemoButtonCanvasLayer/APressed.visible = Input.is_action_pressed("ui_select")
	$DemoButtonCanvasLayer/AUnpressed.visible = not Input.is_action_pressed("ui_select")
