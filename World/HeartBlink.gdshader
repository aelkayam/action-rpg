shader_type canvas_item;

uniform bool active = false;

void fragment(){
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 transparent = vec4(previous_color.r, previous_color.g, previous_color.b, previous_color.a / 2.0);
	COLOR = (active)? transparent : previous_color;
}