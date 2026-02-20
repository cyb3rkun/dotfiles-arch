#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
	mat4 qt_Matrix;
	float qt_Opacity;
	// --- Grouping by 16-byte chunks for alignment ---
	vec4 fillColor;      
	vec4 strokeColor;    
	vec4 cuts;           
	vec4 angles;         
	vec2 size;           
	float bWidth;
	// The driver adds padding here to fill the 16-byte vec4 slot
};

float getEdgeDist(vec2 pixelPos, vec2 cornerPos, float cut, float angleDeg, vec2 dir) {
	if (cut <= 0.0) return 1e6; 

	float rad = radians(angleDeg);
	// Invert the normal: we want positive distance to be INSIDE
	vec2 n = vec2(cos(rad), sin(rad)) * dir;
	vec2 v = pixelPos - cornerPos;

	// We want the distance from the cut line. 
	// dot(v, n) is the projection. 
	return dot(v, n) - cut;
}

void main() {
	// Ensure size isn't zero to avoid math black holes
	vec2 realSize = max(size, vec2(1.0));
	vec2 pixelPos = qt_TexCoord0 * realSize;

	// Distances from the 4 chamfer planes (Positive = Inside)
	float d1 = getEdgeDist(pixelPos, vec2(0.0, 0.0), cuts[0], angles[0], vec2(1.0, 1.0));
	float d2 = getEdgeDist(pixelPos, vec2(realSize.x, 0.0), cuts[1], angles[1], vec2(-1.0, 1.0));
	float d3 = getEdgeDist(pixelPos, vec2(realSize.x, realSize.y), cuts[2], angles[2], vec2(-1.0, -1.0));
	float d4 = getEdgeDist(pixelPos, vec2(0.0, realSize.y), cuts[3], angles[3], vec2(1.0, -1.0));

	// Standard box distance
	float boxX = min(pixelPos.x, realSize.x - pixelPos.x);
	float boxY = min(pixelPos.y, realSize.y - pixelPos.y);
	float rectDist = min(boxX, boxY);

	// The final distance is the intersection of the box and the 4 cuts
	float dist = min(rectDist, min(min(d1, d2), min(d3, d4)));

	// Antialiasing: Use fwidth for screen-space smoothness regardless of zoom
	float aa = 1.0; 
	float mask = smoothstep(-aa, aa, dist);

	// Border: if dist is between 0 and bWidth
	float borderMask = smoothstep(-aa, aa, dist) - smoothstep(bWidth - aa, bWidth + aa, dist);

	vec4 color = mix(fillColor, strokeColor, borderMask);
	fragColor = color * mask * qt_Opacity;
}
