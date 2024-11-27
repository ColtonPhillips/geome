shader_type spatial;

void fragment() {
    // Calculate the vector pointing to the camera
    vec3 to_camera = normalize((CAMERA_POSITION_WORLD - NODE_POSITION_WORLD));
    // Compute the dot product with the surface normal
    float dot_product = 0.5 * (dot(NORMAL, to_camera) + 1.0);
    // Map the dot product to the albedo color
    //ALBEDO = vec3(dot_product, 0.5, 0.5);
    ALBEDO = NORMAL;
}
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
//
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
	//ALBEDO = to_camera * 0.5 + 0.5; // Should show a gradient based on camera direction
//}
