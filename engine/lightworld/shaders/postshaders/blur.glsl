extern float exposure = 0.7;
extern float brightness = 1.0;
extern vec3 lumacomponents = vec3(1.0, 1.0, 1.0);


// luma 
//const vec3 lumcoeff = vec3(0.299,0.587,0.114);
const vec3 lumcoeff = vec3(0.212671, 0.715160, 0.072169);

vec4 effect(vec4 vcolor, Image texture, vec2 texcoord, vec2 pixel_coords)
{	
	vec4 input0 = Texel(texture, texcoord);
	input0 += Texel(texture, vec2(texcoord.x, texcoord.y + 5.0 / 512.0));
	input0 += Texel(texture, vec2(texcoord.x, texcoord.y - 5.0 / 512.0));
	input0 += Texel(texture, vec2(texcoord.x, texcoord.y + 2.0 / 512.0));
	input0 += Texel(texture, vec2(texcoord.x, texcoord.y - 2.0 / 512.0));

	input0 += Texel(texture, vec2(texcoord.x + 5.0 / 512.0, texcoord.y));
	input0 += Texel(texture, vec2(texcoord.x - 5.0 / 512.0, texcoord.y));
	input0 += Texel(texture, vec2(texcoord.x + 2.0 / 512.0, texcoord.y));
	input0 += Texel(texture, vec2(texcoord.x - 2.0 / 512.0, texcoord.y));

	input0 /= 9.0;

	return input0;
} 
