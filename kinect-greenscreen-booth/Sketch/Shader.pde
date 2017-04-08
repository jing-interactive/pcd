PShader shader;

@Parameter(max = 255) float CFG_background_R = 100;
@Parameter(max = 255) float CFG_background_G = 200;
@Parameter(max = 255) float CFG_background_B = 150;
@Parameter(max = 1.732) float CFG_thresh = 0.4; // [0, 1.732] 
@Parameter(max = 1) float CFG_slope = 0.1; // [0, 1] 
@Parameter(max = 2) float CFG_weight_R = 1;
@Parameter(max = 2) float CFG_weight_G = 0.7;
@Parameter(max = 2) float CFG_weight_B = 1;
@Parameter(max = 1) float CFG_x1 = 0.1; // [0, 1] 
@Parameter(max = 1) float CFG_y1 = 0.0; // [0, 1] 
@Parameter(max = 1) float CFG_x2 = 0.9; // [0, 1] 
@Parameter(max = 1) float CFG_y2 = 1.0; // [0, 1] 

void setupShader()
{
  // shader
  shader = loadShader("chroma.glsl");
}

void useShader()
{
  shader.set("keying_color", CFG_background_R / 255, CFG_background_G / 255, CFG_background_B / 255);
  shader.set("thresh", CFG_thresh);
  shader.set("slope", CFG_slope);
  shader.set("weight", CFG_weight_R, CFG_weight_G, CFG_weight_B);
  shader.set("rect_roi", CFG_x1, CFG_y1, CFG_x2, CFG_y2);

  shader(shader);
}

