shader_type spatial;

uniform vec4 color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0); // First stripe color
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Second stripe color
uniform float frequency = 20.0; // Number of zigzag stripes
uniform float amplitude = 5.0; // Width of the zigzag
uniform float speed = 2.0; // Speed of movement

void fragment() {
    // Offset for animation
    float offset = TIME * speed;

    // Zigzag pattern along the y-axis using UV coordinates
    float zigzag = sin((UV.y * frequency) + offset) * amplitude;

    // Create stripes by alternating colors based on the pattern
    if (fract(UV.x + zigzag) < 0.5) {
        ALBEDO = color1.rgb;
    } else {
        ALBEDO = color2.rgb;
    }

    // Set transparency (if needed)
    ALPHA = mix(color1.a, color2.a, step(0.5, fract(UV.x + zigzag)));
}
