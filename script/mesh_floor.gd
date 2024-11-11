extends MeshInstance3D

func _process(delta):
	var material : ShaderMaterial = get_active_material(0)
	material.set_shader_parameter("time", Time.get_ticks_msec() * 0.0001)
