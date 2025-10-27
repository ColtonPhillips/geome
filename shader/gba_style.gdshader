shader_type canvas_item;

uniform sampler2D screen_tex : source_color;
uniform float color_depth = 24.0; // lower = more stylized (try 16–32)
uniform float gamma = 1.1;        // subtle flattening
uniform float saturation = 0.9;   // gentle desaturation
uniform float pixel_scale = 1.0;  // leave at 1.0 for clean stepping

void fragment() {
    // Snap UVs to base resolution for stable pixels
    vec2 base_res = vec2(240.0, 160.0);
    vec2 uv = floor(UV * base_res * pixel_scale) / (base_res * pixel_scale);

    vec4 col = texture(screen_tex, uv);

    // Adjust saturation
    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    col.rgb = mix(vec3(gray), col.rgb, saturation);

    // Quantize colors for stylized palette feel
    col.rgb = floor(col.rgb * color_depth) / color_depth;

    // Mild gamma shaping
    col.rgb = pow(col.rgb, vec3(gamma));

    COLOR = col;
}
