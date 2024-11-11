shader_type spatial;

uniform float time; // For animating the effect
uniform float frequency : hint_range(0.0, 100.0); // Controls wave frequency
uniform float amplitude : hint_range(0.0, 100.0); // Intensity of color effect

// Noise function based on sine waves for color modulation
float noise(vec2 uv) {
    return sin(uv.x * frequency + time) * sin(uv.y * frequency + time);
}

void fragment() {
    // Generate a pseudo-UV based on the vertex position for continuity
    vec2 uv = VERTEX.xz * 0.1; // Scale VERTEX.xz for finer detail

    // Calculate noise
    float n = noise(uv) * amplitude;

    // Base color with noise variation to simulate depth and movement
    vec3 base_color = vec3(0.5, 0.5, 0.7); // Adjust base color as needed
    vec3 color_variation = vec3(0.1 + n * 0.2, 0.5 - n * 0.3, 0.4 + n * 0.2);

    ALBEDO = base_color + 0.8 * color_variation; // Combine base color with noise-based color variation
    ALPHA = 1.0; // Fully opaque
}
