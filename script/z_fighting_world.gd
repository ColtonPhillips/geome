extends Node3D

@export var quad_count: int = 2000  # Number of quads to create
@export var spacing: float = 2.0  # Distance between each quad

func _ready():
	var mesh: QuadMesh = QuadMesh.new()
	mesh.size = Vector2(2.5, 0.6)  # Size of each quad

	for i in range(quad_count):
		# Create a MeshInstance3D for the quad
		var quad_instance = MeshInstance3D.new()
		quad_instance.mesh = mesh
		
		# Position the quad using translate()
		#quad_instance.translate(Vector3(0, 0.5 * i + i*1.5*(0.001 * i), -i * spacing))
		quad_instance.translate(Vector3(0, 0.5 * i, -i * spacing))
		
		# Create a Label3D to cause z-fighting
		var label := Label3D.new()
		label.scale = Vector3(4,4,4)
		label.text = "Quad %d" % i
		label.translate(Vector3(0,0,0.000004))
		#label.billboard_mode = Base3D.BILLBOARD_DISABLED
		
		# Add the label to the quad
		quad_instance.add_child(label)
		add_child(quad_instance)
