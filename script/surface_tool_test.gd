extends Node3D

# Define the size of the cube and triangles
@export var cube_size: float = 1.0
@export var triangle_size: float = 0.5
@export var rotation_speed: float = 30.0  # Rotation speed in degrees per second

var mesh_instance: MeshInstance3D

func _ready():
	# Create the cube with SurfaceTool
	var array_mesh = ArrayMesh.new()
	var surface_tool = SurfaceTool.new()
	
	# Create cube as the first surface
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	_add_cube_vertices(surface_tool, cube_size)
	surface_tool.commit(array_mesh)

	# Create first floating triangle as the second surface
	surface_tool.clear()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	_add_triangle_vertices(surface_tool, Vector3(-2, 2, 0), triangle_size)
	surface_tool.commit(array_mesh)

	# Create second floating triangle
	surface_tool.clear()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	_add_triangle_vertices(surface_tool, Vector3(2, 2, 0), triangle_size)
	surface_tool.commit(array_mesh)

	# Create third floating triangle
	surface_tool.clear()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	_add_triangle_vertices(surface_tool, Vector3(0, -2, 2), triangle_size)
	surface_tool.commit(array_mesh)

	# Attach the ArrayMesh to a MeshInstance3D
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = array_mesh
	add_child(mesh_instance)

# Helper function to add cube vertices (ensure counter-clockwise winding)
func _add_cube_vertices(st: SurfaceTool, size: float):
	var half_size = size * 0.5
	var vertices = [
		Vector3(-half_size, -half_size, -half_size),  # 0 Front Bottom Left
		Vector3(half_size, -half_size, -half_size),   # 1 Front Bottom Right
		Vector3(half_size, half_size, -half_size),    # 2 Front Top Right
		Vector3(-half_size, half_size, -half_size),   # 3 Front Top Left
		Vector3(-half_size, -half_size, half_size),   # 4 Back Bottom Left
		Vector3(half_size, -half_size, half_size),    # 5 Back Bottom Right
		Vector3(half_size, half_size, half_size),     # 6 Back Top Right
		Vector3(-half_size, half_size, half_size)     # 7 Back Top Left
	]
	
	# Back face (counter-clockwise winding)
	st.add_vertex(vertices[0])  # Front Bottom Left
	st.add_vertex(vertices[1])  # Front Bottom Right
	st.add_vertex(vertices[2])  # Front Top Right

	st.add_vertex(vertices[2])
	st.add_vertex(vertices[3])  # Front Top Left
	st.add_vertex(vertices[0])  # Front Bottom Left

	# Front face (counter-clockwise winding)
	st.add_vertex(vertices[4])  # Back Bottom Left
	st.add_vertex(vertices[5])  # Back Bottom Right
	st.add_vertex(vertices[6])  # Back Top Right

	st.add_vertex(vertices[6])
	st.add_vertex(vertices[7])  # Back Top Left
	st.add_vertex(vertices[4])  # Back Bottom Left

	# Bottom face (counter-clockwise winding)
	st.add_vertex(vertices[0])  # Front Bottom Left
	st.add_vertex(vertices[1])  # Front Bottom Right
	st.add_vertex(vertices[5])  # Back Bottom Right

	st.add_vertex(vertices[5])
	st.add_vertex(vertices[4])  # Back Bottom Left
	st.add_vertex(vertices[0])  # Front Bottom Left

	# Right face (counter-clockwise winding)
	st.add_vertex(vertices[1])  # Front Bottom Right
	st.add_vertex(vertices[2])  # Front Top Right
	st.add_vertex(vertices[6])  # Back Top Right

	st.add_vertex(vertices[6])
	st.add_vertex(vertices[5])  # Back Bottom Right
	st.add_vertex(vertices[1])  # Front Bottom Right

	# Top face (counter-clockwise winding)
	st.add_vertex(vertices[2])  # Front Top Right
	st.add_vertex(vertices[3])  # Front Top Left
	st.add_vertex(vertices[7])  # Back Top Left

	st.add_vertex(vertices[7])
	st.add_vertex(vertices[6])  # Back Top Right
	st.add_vertex(vertices[2])  # Front Top Right

	# Left face (counter-clockwise winding)
	st.add_vertex(vertices[3])  # Front Top Left
	st.add_vertex(vertices[0])  # Front Bottom Left
	st.add_vertex(vertices[4])  # Back Bottom Left

	st.add_vertex(vertices[4])
	st.add_vertex(vertices[7])  # Back Top Left
	st.add_vertex(vertices[3])  # Front Top Left

# Helper function to add triangle vertices (counter-clockwise winding)
func _add_triangle_vertices(st: SurfaceTool, offset: Vector3, size: float):
	var half_size = size * 0.5
	var vertices = [
		Vector3(0, half_size, 0), 
		Vector3(-half_size, -half_size, 0), 
		Vector3(half_size, -half_size, 0)
	]
	for vertex in vertices:
		st.add_vertex(vertex + offset)

# Rotate the cube around the Y-axis
func _process(delta: float):
	# Apply rotation around the Y-axis
	mesh_instance.rotate_y(deg_to_rad(rotation_speed * delta))
