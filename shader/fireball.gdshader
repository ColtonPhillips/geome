shader_type spatial;

uniform vec4 fire_color : source_color = vec4(1.0, 0.5, 0.0, 1.0); // Fire color
uniform float intensity = 1.5; // Intensity of the emission
uniform float speed = 1.0; // Animation speed
uniform float noise_scale = 5.0; // Scale of the noise pattern

// Noise texture to create a fire-like pattern (assign this in the material settings)
uniform sampler2D noise_texture;

void fragment() {
    // Coordinates for the noise texture
    vec3 uv_coords = vec3(UV, TIME * speed);

    // Sample noise texture to create movement
    float noise = texture(noise_texture, uv_coords.xy * noise_scale).r;

    // Generate color for the fireball
    vec3 fireball_color = fire_color.rgb * noise * intensity;

    // Apply emission for the fireball glow effect
    EMISSION = fireball_color;

    // Set base albedo color to influence the look of the sphere under different lighting
    ALBEDO = fire_color.rgb * 0.3;
}
