PShader shader;

float keyingR = 255;
float keyingG = 255;
float keyingB = 255;
float thresh = 1; // [0, 1.732] 
float slope = 0.3; // [0, 1] 

void setupShader()
{
  // shader
  shader = loadShader("chroma.glsl");
}

void useShader()
{
  shader.set("keying_color", keyingR / 255, keyingG / 255, keyingB / 255);
  shader.set("thresh", thresh);
  shader.set("slope", slope);
  shader(shader);
}

