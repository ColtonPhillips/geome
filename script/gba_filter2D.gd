@tool

extends Control

@export var base_resolution: Vector2i = Vector2i(240, 160)
@export_range(8, 64, 1) var color_depth := 24.0
@export_range(0.8, 1.5, 0.01) var gamma := 1.1
@export_range(0.0, 1.0, 0.01) var saturation := 0.9

var viewport: SubViewport
var rect: TextureRect

func _ready():
	if Engine.is_editor_hint(): return
	_build()
	_update_shader_params()

func _build():
	viewport = SubViewport.new()
	viewport.size = base_resolution
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.disable_3d = true
	viewport.transparent_bg = false
	viewport.msaa_2d = Viewport.MSAA_DISABLED
	add_child(viewport)

	rect = TextureRect.new()
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	rect.anchor_left = 0
	rect.anchor_right = 1
	rect.anchor_top = 0
	rect.anchor_bottom = 1
	rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rect.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var mat := ShaderMaterial.new()
	mat.shader = load("res://addons/gba_filter/gba_style.gdshader")
	rect.material = mat
	add_child(rect)

	rect.texture = viewport.get_texture()

func _update_shader_params():
	if not rect or not rect.material:
		return
	var mat := rect.material as ShaderMaterial
	mat.set_shader_parameter("color_depth", color_depth)
	mat.set_shader_parameter("gamma", gamma)
	mat.set_shader_parameter("saturation", saturation)

func _process(_delta):
	if not viewport: return
	viewport.size = base_resolution
	_update_shader_params()
