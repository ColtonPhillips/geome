extends Node3D

@export var line_length: float = 0.5  # Length of the normal lines

func _ready():
	visualize_normals()

func visualize_normals():
	# Get the parent mesh instance
	var parent_mesh = $MeshInstance3D
	if not parent_mesh or not parent_mesh.mesh:
		return
	
	# Create an ImmediateMesh
	var immediate_mesh = ImmediateMesh.new()
	
	# Get the global transform of the parent mesh
	var parent_global_transform = parent_mesh.global_transform
	print("Parent Global Transform: ", parent_global_transform)  # Debug: print global transform of parent
	
	for surface_idx in parent_mesh.mesh.get_surface_count():
		# Fetch vertex and normal data from the mesh
		var surface_array = parent_mesh.mesh.surface_get_arrays(surface_idx)
		if not surface_array or surface_array.size() == 0:
			continue
		
		var vertices = surface_array[Mesh.ARRAY_VERTEX]
		var normals = surface_array[Mesh.ARRAY_NORMAL]
		
		if vertices.size() != normals.size():
			continue  # Ensure we have matching vertices and normals
		
		immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
		
		for i in range(vertices.size()):
			var vertex = vertices[i]
			var normal = normals[i]
			
			# Debug: print the local vertex and normal before transformation
			print("Local Vertex: ", vertex)  # Debug: print local vertex
			print("Local Normal: ", normal)  # Debug: print local normal
			
			# Transform the vertex into world space using the parent mesh's global transform
			var global_vertex = parent_global_transform.basis * vertex + parent_global_transform.origin
			# Transform the normal into world space using only the parent mesh's basis (no translation)
			var global_normal = parent_global_transform.basis * normal
			
			# Normalize the normal (to ensure it's a unit vector)
			global_normal = global_normal.normalized()
			
			# Debug: print the transformed vertex and normal in world space
			print("Transformed Global Vertex: ", global_vertex)  # Debug: print global vertex
			print("Transformed Global Normal: ", global_normal)  # Debug: print global normal
			
			# Draw the line from the vertex along the normal
			immediate_mesh.surface_add_vertex(global_vertex)
			immediate_mesh.surface_add_vertex(global_vertex + global_normal * line_length)
		
		immediate_mesh.surface_end()
	
	# Assign the ImmediateMesh to a new MeshInstance3D
	var normal_lines_instance = $ImmediateMeshInstance3D
	normal_lines_instance.mesh = immediate_mesh
	
	# Debug: print the global transform of the ImmediateMesh instance
	print("ImmediateMesh Instance Global Transform: ", normal_lines_instance.global_transform)  # Debug: print the global transform of ImmediateMesh instance
	
	# Align ImmediateMeshInstance3D to MeshInstance3D using the global transform
	normal_lines_instance.global_transform = parent_global_transform
