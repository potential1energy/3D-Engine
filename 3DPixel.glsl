varying vec4 vposcam;
varying vec3 vertexNormal;
varying vec4 vertexColor;
extern vec4 SunPos;

struct Vert {
	vec3 Pos;
	vec2 Uv;
	vec3 Vn;
	vec4 Color;
};

Vert MeshVerts[1000000];

float distance3D(float x, float y, float z)
{
	return sqrt((x * x) + ((y * y) + (z * z)));
}

vec4 getVector(vec4 pos, vec4 targ)
{
	float vx = targ.x - pos.x;
	float vy = targ.y - pos.y;
	float vz = targ.z - pos.z;
	float len = sqrt(vx*vx + vy*vy + vz*vz);

	if (len > 0) {
		return vec4(vx/len, vy/len, vz/len, 0);
	}
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec4 s = getVector(vposcam, SunPos);


	vec4 white = vec4(1.0,1.0,1.0,1.0);

	vec4 n = vec4(vertexNormal, 0);

	float d = dot(n,s);

	vec4 C = Texel(texture, texture_coords);

	return vec4(d, d, d, 1.0) * C;
}