extends Node3D

@export var width: int = 20
@export var depth: int = 20
@export var terrain_scale: float = 2.0
@export var height_multiplier: float = 2.0 # Makes the height calculation adjustable
@export var noise_frequency: float = 0.2   # Adjusts the rolling effect of the terrain

func _ready():
	generate_terrain()

func generate_terrain():
	
	# Calculate half-width and half-depth to center the terrain
	var half_width = (width - 1) * terrain_scale * 0.5
	var half_depth = (depth - 1) * terrain_scale * 0.5

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Generate vertices and create the terrain
	generate_vertices(st, half_width, half_depth)

	st.generate_normals()
	var mesh = st.commit()
	
	# Assign the generated mesh to the MeshInstance3D
	$MeshInstance3D.mesh = mesh

	 #Create collision shape (optional, commented out for now)
	#var collision = PhysicsServer3D.mesh_create_shape(mesh)
	#$StaticBody3D.shape = mesh.create_trimesh_shape()
	$StaticBody3D/CollisionShape3D.shape = mesh.create_trimesh_shape()


func generate_vertices(st: SurfaceTool, half_width: float, half_depth: float):
	for x in range(width - 1):
		for z in range(depth - 1):
			# Get the four corners of the current grid square, centered
			var v0 = Vector3(x * terrain_scale - half_width, calculate_height(x, z), z * terrain_scale - half_depth)
			var v1 = Vector3((x + 1) * terrain_scale - half_width, calculate_height(x + 1, z), z * terrain_scale - half_depth)
			var v2 = Vector3(x * terrain_scale - half_width, calculate_height(x, z + 1), (z + 1) * terrain_scale - half_depth)
			var v3 = Vector3((x + 1) * terrain_scale - half_width, calculate_height(x + 1, z + 1), (z + 1) * terrain_scale - half_depth)

			# Triangle 1: v0, v1, v2
			add_vertex(st, v0)
			add_vertex(st, v1)
			add_vertex(st, v2)

			# Triangle 2: v2, v1, v3
			add_vertex(st, v2)
			add_vertex(st, v1)
			add_vertex(st, v3)

# Function to calculate height based on noise and multipliers
func calculate_height(x: int, z: int) -> float:
	return sin(x * noise_frequency) * height_multiplier + cos(z * noise_frequency) * height_multiplier

# Function to add a single vertex to the SurfaceTool
func add_vertex(st: SurfaceTool, pos: Vector3):
	st.add_vertex(pos)
