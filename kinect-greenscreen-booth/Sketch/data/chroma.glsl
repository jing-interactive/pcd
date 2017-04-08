#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

// p5-predefined values
#define PROCESSING_TEXTURE_SHADER
uniform sampler2D fg;
uniform sampler2D textile;
uniform sampler2D realtime;
uniform sampler2D bg;
uniform bvec4 texFlags;
#define fgEnabled texFlags.x
#define textileEnabled texFlags.y
#define realtimeEnabled texFlags.z
#define bgEnabled texFlags.w

uniform vec2 texOffset;
varying vec4 vertColor;
varying vec4 vertTexCoord;
 
// user-configurable variables (read-only) 
uniform vec3 keying_color; 
uniform float thresh; // [0, 1.732] 
uniform float slope; // [0, 1] 
uniform vec3 weight; // (1, 0.7, 1)

uniform vec4 rect_roi;
#define X1 rect_roi.r
#define Y1 rect_roi.g
#define X2 rect_roi.b
#define Y2 rect_roi.a

void main(void)
{
	vec3 realtime_color = vec3(0);
	float alpha = 0;
	if (vertTexCoord.s > X1 &&
	vertTexCoord.t > Y1 && 
	vertTexCoord.s < X2 &&
	vertTexCoord.t < Y2 )
	{
	    realtime_color = texture2D(realtime, vertTexCoord.st).rgb;

	    float dist = distance(keying_color * weight, realtime_color * weight);
	    float edge0 = thresh * (1.0 - slope);
	    alpha = smoothstep(edge0, thresh, dist);
	}

    vec3 bg_color = vec3(0,0,0);
    if (bgEnabled) bg_color = texture2D(bg, vertTexCoord.st).rgb;

    vec3 rgb = mix(bg_color, realtime_color, alpha);

    if (fgEnabled)
    {
    	vec4 fg_color = texture2D(fg, vertTexCoord.st);
	    rgb = mix(rgb, fg_color.rgb, fg_color.a);
    }

    if (textileEnabled)
    {
    	vec3 textile_color = texture2D(textile, vertTexCoord.st).rgb;
	    rgb = mix(rgb, textile_color, 0.5);
	}

	gl_FragColor.rgb = rgb;
}
