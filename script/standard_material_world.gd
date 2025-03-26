extends Node3D

@onready var node_3d: Node3D = $Node3D

# Rotation speeds in radians per second
var rotation_speed_x := 1.0
var rotation_speed_y := 2.0
var rotation_speed_z := 0.5

func _ready() -> void:
	for child in node_3d.get_children():
		if child is Node3D:
			add_label_to_mesh(child)

func _process(delta: float) -> void:
	for child in node_3d.get_children():
		if child is Node3D:
			# Rotate the mesh
			child.rotate_x(rotation_speed_x * delta)
			child.rotate_y(rotation_speed_y * delta)
			child.rotate_z(rotation_speed_z * delta)
			
			# Update label position
			var label = child.get_node_or_null("Label3D")
			if label:
				label.global_position = child.global_position + Vector3(0, 1.5, 0)  # Adjust height above the mesh

func add_label_to_mesh(mesh: Node3D) -> void:
	var label = Label3D.new()
	label.name = "Label3D"
	label.text = mesh.name  # Set label text to the mesh's name
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED  # Makes it always face the camera
	label.pixel_size = 0.01  # Adjust for readability
	label.position = Vector3(0, 1.5, 0)  # Place it slightly above the mesh
	mesh.add_child(label)
