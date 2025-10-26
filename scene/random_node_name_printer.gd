extends Node3D

var http_request_json: HTTPRequest
var http_request_cat: HTTPRequest

func _ready() -> void:
	# -- JSON REQUEST SETUP --
	http_request_json = HTTPRequest.new()
	add_child(http_request_json)
	http_request_json.request_completed.connect(_on_http_json_completed)
	var err = http_request_json.request("https://httpbin.org/get")
	if err != OK:
		push_error("JSON HTTP request failed.")

	# -- CAT REQUEST SETUP --
	http_request_cat = HTTPRequest.new()
	add_child(http_request_cat)
	http_request_cat.request_completed.connect(_on_cat_completed)
	err = http_request_cat.request("https://cataas.com/cat/orange,cute")
	if err != OK:
		push_error("Cat HTTP request failed.")


func _on_http_json_completed(_result, _code, _headers, body):
	var json = JSON.new()
	if json.parse(body.get_string_from_utf8()) != OK:
		push_error("Failed to parse JSON.")
		return

	var body_str = body.get_string_from_utf8().substr(0, 100)

	# Pick a random Node class
	var node_classes = []
	for c in ClassDB.get_class_list():
		if ClassDB.is_parent_class(c, "Node"):
			node_classes.append(c)

	if node_classes.size() == 0:
		push_error("No Node classes found.")
		return

	var random_class = node_classes[randi() % node_classes.size()]

	# 3D text for random class (BIG + YELLOW)
	var class_label = Label3D.new()
	class_label.text = random_class
	class_label.position = Vector3(0, 1.5, 0)
	class_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	class_label.modulate = Color(1.0, 0.9, 0.2)
	class_label.font_size = 64
	add_child(class_label)

	# 3D text for API snippet (lower)
	var api_label = Label3D.new()
	api_label.text = body_str
	api_label.position = Vector3(0, 0.5, 0)
	api_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	api_label.modulate = Color(0.8, 0.9, 1.0)
	api_label.font_size = 32
	add_child(api_label)


func _on_cat_completed(_result, _code, _headers, body):
	var image = Image.new()
	var err = image.load_png_from_buffer(body)
	if err != OK:
		image = _try_gif_as_texture(body)
		if image == null:
			push_error("Could not create cat texture.")
			return

	var texture = ImageTexture.create_from_image(image)

	# Cat plane
	var plane = MeshInstance3D.new()
	var mesh = PlaneMesh.new()
	mesh.size = Vector2(1.5, 1.5)
	plane.mesh = mesh

	var mat = StandardMaterial3D.new()
	mat.albedo_texture = texture
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_DISABLED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED   # render on both sides
	plane.material_override = mat

	# Rotate the plane in 3D so it's not flat
	plane.rotation_degrees = Vector3(-20, 90, 0)  # tilt slightly in X, rotate 90° Y
	plane.position = Vector3(-2.5, 0.5, 0)

	add_child(plane)
	
func _try_gif_as_texture(body: PackedByteArray) -> Image:
	var image = Image.new()
	if image.load_jpg_from_buffer(body) == OK:
		return image
	if image.load_png_from_buffer(body) == OK:
		return image
	return null
