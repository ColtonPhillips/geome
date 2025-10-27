shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 viewport_size; // 👈 We'll auto-set this via a script

uniform float pixel_scale : hint_range(0.5, 8.0) = 2.0;
uniform float vignette_strength : hint_range(0.0, 1.5) = 0.6;
uniform float vignette_softness : hint_range(0.01, 1.0) = 0.3;
uniform float aberration_strength : hint_range(0.0, 2.0) = 0.4;
uniform bool posterize_enabled = false;
uniform int posterize_levels : hint_range(2, 3200) = 6;

void fragment() {
    vec2 uv = SCREEN_UV;

    // ---- Pixelation ----
    vec2 pixel_uv = floor(uv * pixel_scale * viewport_size) / (pixel_scale * viewport_size);
    vec3 base_color = texture(SCREEN_TEXTURE, pixel_uv).rgb;

    // ---- Chromatic Aberration ----
    vec3 color;
    color.r = texture(SCREEN_TEXTURE, pixel_uv + vec2(aberration_strength / viewport_size.x, 0.0)).r;
    color.g = base_color.g;
    color.b = texture(SCREEN_TEXTURE, pixel_uv - vec2(aberration_strength / viewport_size.x, 0.0)).b;

    // ---- Vignette ----
    float dist = length(uv - vec2(0.5));
float vignette = smoothstep(vignette_softness, 0.8, dist);
color *= 1.0 - vignette_strength * vignette;

    // ---- Posterization ----
    if (posterize_enabled) {
        color = floor(color * float(posterize_levels)) / float(posterize_levels);
    }

    COLOR = vec4(color, 1.0);
}
