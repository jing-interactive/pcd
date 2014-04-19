#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

// p5-predefined values
#define PROCESSING_TEXTURE_SHADER
uniform sampler2D texture;
uniform vec2 texOffset;
varying vec4 vertColor;
varying vec4 vertTexCoord;
 
// user-configurable variables (read-only) 
uniform vec3 keying_color; 
uniform float thresh; // [0, 1.732] 
uniform float slope; // [0, 1] 

void main(void)
{
    vec3 input_color = texture2D(texture, vertTexCoord.st).rgb;
    float dist = distance(keying_color.rgb, input_color.rgb);
    float edge0 = thresh * (1.0 - slope);
    float alpha = smoothstep(edge0, thresh, dist);
    gl_FragColor = vec4(input_color, alpha);
}
