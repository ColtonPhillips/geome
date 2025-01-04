extends Node3D

# Define the size of the cube and triangles
@export var cube_size: float = 0.8	
@export var triangle_size: float = 1.4	
@export var rotation_speed: float = 20.0  # Rotation speed in degrees per second

var mesh_instance: MeshInstance3D

func _ready():
	# Create the cube with SurfaceTool
	var array_mesh = ArrayMesh.new()
	var surface_tool = SurfaceTool.new()
	
	# Create cube as the first surface
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	_fixed_add_cube_vertices(surface_tool, cube_size)
	surface_tool.generate_normals()
	surface_tool.commit(array_mesh)

	# Iterate over all possible Vector3 combinations with components of 1 or -1
	for x in [-1, 1]:
		for y in [-1, 1]:
			for z in [-1, 1]:
				var position = Vector3(x, y, z)
				_add_triangle_vertices(array_mesh, surface_tool, position, triangle_size)

	# Attach the ArrayMesh to a MeshInstance3D
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = array_mesh
	add_child(mesh_instance)

# Helper function to add cube vertices (ensure counter-clockwise winding)
func _add_cube_vertices(st: SurfaceTool, size: float):
	var one = size * 0.5
	var vertices = {
		"A": Vector3(-one, -one, one),  # Front Bottom Left
		"B": Vector3(-one, one, one),   # Front Bottom Right
		"C": Vector3(one, one, one),    # Front Top Right
		"D": Vector3(one, -one, one),   # Front Top Left
		"W": Vector3(one, -one, -one),   # Back Bottom Left
		"X": Vector3(one, one, -one),    # Back Bottom Right
		"Y": Vector3(-one, one, -one),     # Back Top Right
		"Z": Vector3(-one, -one, -one)     # Back Top Left
	}

	
	st.add_vertex(vertices["A"])  # Front Bottom Left
	st.add_vertex(vertices["B"])  # Front Bottom Right
	st.add_vertex(vertices["C"])  # Front Top Right

	st.add_vertex(vertices["A"])
	st.add_vertex(vertices["C"])  # Front Top Left
	st.add_vertex(vertices["D"])  # Front Bottom Left

	st.add_vertex(vertices["C"])  # Back Bottom Left
	st.add_vertex(vertices["X"])  # Back Bottom Right
	st.add_vertex(vertices["D"])  # Back Top Right

	st.add_vertex(vertices["D"])
	st.add_vertex(vertices["X"])  # Back Top Left
	st.add_vertex(vertices["W"])  # Back Bottom Left

	st.add_vertex(vertices["B"])  # Front Bottom Left
	st.add_vertex(vertices["Z"])  # Front Bottom Right
	st.add_vertex(vertices["Y"])  # Back Bottom Right

	st.add_vertex(vertices["B"])
	st.add_vertex(vertices["A"])  # Back Bottom Left
	st.add_vertex(vertices["Z"])  # Front Bottom Left

	st.add_vertex(vertices["A"])  # Front Bottom Right
	st.add_vertex(vertices["D"])  # Front Top Right
	st.add_vertex(vertices["Z"])  # Back Top Right

	st.add_vertex(vertices["D"])
	st.add_vertex(vertices["W"])  # Back Bottom Right
	st.add_vertex(vertices["Z"])  # Front Bottom Right

	st.add_vertex(vertices["B"])  # Front Top Right
	st.add_vertex(vertices["Y"])  # Front Top Left
	st.add_vertex(vertices["C"])  # Back Top Left

	st.add_vertex(vertices["C"])
	st.add_vertex(vertices["Y"])  # Back Top Right
	st.add_vertex(vertices["X"])  # Front Top Right

	st.add_vertex(vertices["W"])  # Front Top Left
	st.add_vertex(vertices["X"])  # Front Bottom Left
	st.add_vertex(vertices["Z"])  # Back Bottom Left

	st.add_vertex(vertices["Z"])
	st.add_vertex(vertices["X"])  # Back Top Left
	st.add_vertex(vertices["Y"])  # Front Top Left
	
# Helper function to add cube vertices with consistent CCW winding
func _fixed_add_cube_vertices(st: SurfaceTool, size: float):
	var one = size * 0.5
	var vertices = {
		"A": Vector3(-one, -one, one),  # Front Bottom Left
		"B": Vector3(-one, one, one),   # Front Top Left
		"C": Vector3(one, one, one),    # Front Top Right
		"D": Vector3(one, -one, one),   # Front Bottom Right
		"W": Vector3(one, -one, -one),  # Back Bottom Right
		"X": Vector3(one, one, -one),   # Back Top Right
		"Y": Vector3(-one, one, -one),  # Back Top Left
		"Z": Vector3(-one, -one, -one)  # Back Bottom Left
	}

	# Front face
	st.add_vertex(vertices["A"])
	st.add_vertex(vertices["B"])
	st.add_vertex(vertices["C"])
	st.add_vertex(vertices["A"])
	st.add_vertex(vertices["C"])
	st.add_vertex(vertices["D"])

	# Back face
	st.add_vertex(vertices["W"])
	st.add_vertex(vertices["X"])
	st.add_vertex(vertices["Y"])
	st.add_vertex(vertices["W"])
	st.add_vertex(vertices["Y"])
	st.add_vertex(vertices["Z"])

	# Left face
	st.add_vertex(vertices["A"])
	st.add_vertex(vertices["Z"])
	st.add_vertex(vertices["Y"])
	st.add_vertex(vertices["A"])
	st.add_vertex(vertices["Y"])
	st.add_vertex(vertices["B"])

	# Right face
	st.add_vertex(vertices["D"])
	st.add_vertex(vertices["C"])
	st.add_vertex(vertices["X"])
	st.add_vertex(vertices["D"])
	st.add_vertex(vertices["X"])
	st.add_vertex(vertices["W"])

	# Top face
	st.add_vertex(vertices["B"])
	st.add_vertex(vertices["Y"])
	st.add_vertex(vertices["X"])
	st.add_vertex(vertices["B"])
	st.add_vertex(vertices["X"])
	st.add_vertex(vertices["C"])

	# Bottom face
	st.add_vertex(vertices["A"])
	st.add_vertex(vertices["D"])
	st.add_vertex(vertices["W"])
	st.add_vertex(vertices["A"])
	st.add_vertex(vertices["W"])
	st.add_vertex(vertices["Z"])


# Helper function to add triangle vertices (counter-clockwise winding)
func _add_triangle_vertices(arrayMesh: ArrayMesh, st: SurfaceTool, offset: Vector3, size: float):
	var one = size * 0.5
	var vertices = [
		Vector3(0, one, 0), 
		Vector3(one, one, 0), 
		Vector3(0, 0, 0)
	]
	
	var rev_vertices = [
		Vector3(0, 0, 0),
		Vector3(one, one, 0), 
		Vector3(0, one, 0) 
	]
	
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for vertex in vertices:
		st.add_vertex(vertex + offset)
		
	st.generate_normals()
	st.commit(arrayMesh)
	
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for vertex in rev_vertices:
		st.add_vertex(vertex + offset)
	st.generate_normals()
	st.commit(arrayMesh)

# Rotate the cube around the Y-axis
func _process(delta: float):
	# Apply rotation around the Y-axis
	mesh_instance.rotate_y(deg_to_rad(rotation_speed * delta))
	mesh_instance.rotate_x(deg_to_rad(0.5 * rotation_speed * delta))
	mesh_instance.rotate_z(deg_to_rad(0.1 * rotation_speed * delta))
