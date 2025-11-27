cbuffer Uniforms : register(b0)
{
  float2 iResolution;
};

struct PSInput
{
  float4 position : SV_Position;
};

float RenderRed(float position, float maxPosition)
{
  float grid = frac((position / 60));
  float red = step(1.0 / 6.0, grid);
  return red;
}

float4 main(PSInput input) : SV_Target
{
  float2 fragPos = input.position.xy;
  float x = RenderRed(fragPos.x, iResolution.x);
  float y = RenderRed(fragPos.y, iResolution.y);
  float t = step(2.0, x + y);

  float3 final = float3(1.0, 0.0, 0.0) * t;
  
  return float4(final, 1.0); 
}
