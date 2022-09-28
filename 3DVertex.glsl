extern mat4 proj;
extern vec4 campos;
extern vec4 camrotS;
extern vec4 camrotC;
varying vec4 vposcam;
uniform bool isCanvasEnabled;
varying vec3 vertexNormal;
varying vec4 vertexColor;

attribute vec3 VertexNormal;

float distance3D(float x, float y, float z)
{
	return sqrt((x * x) + ((y * y) + (z * z)));
}

vec4 rotateVecX(vec4 position)
{
    vec4 rotated;
    rotated.x = (position.z * camrotS.y) + (position.x * camrotC.y);
    rotated.y = position.y;
    rotated.z = (position.z * camrotC.y) - (position.x * camrotS.y);
    rotated.w = position.w;

    return rotated;
}
vec4 rotateVecY(vec4 position)
{
    vec4 rotated;
    rotated.x = position.x;
    rotated.y = (position.z * camrotS.x) + (position.y * camrotC.x);
    rotated.z = (position.z * camrotC.x) - (position.y * camrotS.x);
    rotated.w = position.w;

    return rotated;
}

vec4 position(mat4 transform, vec4 vertex_pos)
{

    if (isCanvasEnabled) {
        vertex_pos.y *= -1.0;
    }
    
    vertexNormal = VertexNormal;
    vertexColor = VertexColor;

    vec4 rotatedpos = rotateVecX(vertex_pos + campos);
    rotatedpos = rotateVecY(rotatedpos);
    vposcam = rotatedpos;

    return proj * rotatedpos;
}