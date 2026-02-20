#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
	mat4 qt_Matrix;
	float qt_Opacity;
	vec4 fillColor;
	vec4 strokeColor;
	float bWidth;
	float skewFactor;
	vec2 size; // New: width and height in pixels
};

void main() {
	vec2 uv = qt_TexCoord0;
	
	float absSkew = abs(skewFactor);
	float innerWidth = 1.0 - absSkew;

	float xOffset;
	if (skewFactor >= 0.0) {
		xOffset = skewFactor * (1.0 - uv.y);
	} else {
		xOffset = absSkew * uv.y;
	}
	float skewedX = uv.x - xOffset;

	// Antialiasing?
	float smoothing = 1.5; 
	float deltaX = fwidth(skewedX) * 0.75;
	float deltaY = fwidth(uv.y) * 0.75;

	// Smooth edges
	float leftEdge = smoothstep(0.0, deltaX, skewedX);
	float rightEdge = 1.0 - smoothstep(innerWidth - deltaX, innerWidth, skewedX);
	float topEdge = smoothstep(0.0, deltaY, uv.y);
	float bottomEdge = 1.0 - smoothstep(1.0 - deltaY, 1.0, uv.y);

	float mask = leftEdge * rightEdge * topEdge * bottomEdge;

	// --- BORDER LOGIC ---
	float borderMask = 0.0;
	if (bWidth > 0.0) {
		// We normalize the border width to UV coordinates
		float bX = bWidth / size.x;
		float bY = bWidth / size.y;

		float bLeft = smoothstep(bX, bX + deltaX, skewedX);
		float bRight = 1.0 - smoothstep(innerWidth - bX - deltaX, innerWidth - bX, skewedX);
		float bTop = smoothstep(bY, bY + deltaY, uv.y);
		float bBottom = 1.0 - smoothstep(1.0 - bY - deltaY, 1.0, uv.y);

		borderMask = bLeft * bRight * bTop * bBottom;
	}

	vec4 finalColor = mix(fillColor, strokeColor, borderMask);

	// Apply the opacity and the smoothing mask
	fragColor = finalColor * mask * qt_Opacity;
}
