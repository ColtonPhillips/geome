shader_type spatial;

uniform vec4 color_back : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Fire color
uniform vec4 color_front : source_color = vec4(0.0, 0.0, 1.0, 1.0); // Fire color

//void fragment() {
    //// Get the normal in view space
    //vec3 normal_view = normalize(NORMAL);
	//
    //// Calculate the direction from the camera to the fragment
    //vec3 view_dir = normalize(CAMERA_DIRECTION_WORLD - NODE_POSITION_WORLD);
	//
    //// Calculate the dot product to find the angle similarity
    //float angle_factor = normalize(dot(CAMERA_DIRECTION_WORLD, NORMAL));
//
    //// Remap the dot product range (-1 to 1) to (0 to 1)
    //angle_factor = (angle_factor + 1.0) * 0.5;
//
    //// Interpolate between the two colors based on the angle factor
    //vec4 final_color = mix(opposite_color, facing_color, angle_factor);
//
    //ALBEDO = final_color.rgb;
    //ALPHA = final_color.a;
//}


//void fragment() {
    // Calculate the vector pointing to the camera
    //vec3 to_camera = normalize((CAMERA_POSITION_WORLD - NODE_POSITION_WORLD));
	//CAMERA_DIRECTION_WORLD
    // Compute the dot product with the surface normal
    //float dot_product = 0.5 * (dot(NORMAL, CAMERA_DIRECTION_WORLD) + 1.0);

    // Map the dot product to the albedo color
    //ALBEDO = vec3(dot_product, 0.5, 0.5);
    //ALBEDO = ALBEDO * dot(NORMAL, CAMERA_DIRECTION_WORLD);
    //ALBEDO = dot(NORMAL, CAMERA_DIRECTION_WORLD);
//}
//
//shader_type spatial;
//
//void fragment() {
    //// Calculate the vector pointing to the camera
    //vec3 to_camera = normalize(CAMERA_POSITION_WORLD - NODE_POSITION_WORLD);
    //// Compute the dot product between the normal and the direction to the camera
    //float dot_product = max(dot(NORMAL, to_camera), 0.0);
    //// Use the dot product to set the ALBEDO color
    //ALBEDO = vec3(dot_product); // Shades of gray based on alignment
////}
//
//shader_type spatial;
////render_mode	unshaded;
//void fragment() {
    //// Get the camera's view direction (from the fragment to the camera)
//
    //// Get the normal of the fragment
    //vec3 normal = normalize(NORMAL);
//
    //// Compute the dot product between the view direction and normal
//
    //// Use the square root of the absolute dot product to smooth the transition
//
    //// Interpolate the colors based on the smoothed dot product
//}
//render_mode world_vertex_coords;
render_mode unshaded;
//render_mode world_vertex_coords;
void fragment() {
    // Normalize the world-space normal

	//ALBEDO = (0.5 * NORMAL + 0.5);

    // Convert the normal vector to RGB colors
    //vec3 normal_map_color = world_normal * 0.5 + 0.5; // Remap to [0, 1]
    //vec3 normal_map_color = 0.5 * (world_normal + NORMAL); // Remap to [0, 1]
	ALBEDO = mix(NORMAL, CAMERA_DIRECTION_WORLD, 0.5);
}

//void fragment() {
    //// Convert the normal to world space
    //vec3 normal_world = normalize((MODEL_NORMAL_MATRIX * NORMAL).xyz);
    //
    //// Calculate the vector pointing to the camera
    //vec3 to_camera = normalize(CAMERA_POSITION_WORLD - NODE_POSITION_WORLD);
    //
    //// Compute the dot product between the world-space normal and the direction to the camera
    //float dot_product = max(dot(normal_world, to_camera), 0.0);
	//
    //// Use the dot product to set the ALBEDO color
    ////ALBEDO = vec3(dot_product); // Shades of gray based on alignment
	////ALBEDO = normal_world * 0.5 + 0.5; // Should show surface directions
	////ALBEDO.rgb = vec3(NORMAL.x, NORMAL.z, NORMAL.y); // Should show a gradient based on camera direction
	//float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	//ALBEDO = normalize(NORMAL);
	//}
