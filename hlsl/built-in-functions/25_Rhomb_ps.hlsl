cbuffer Uniforms : register(b0)
{
  float2 iResolution;
};

struct PSInput
{
  float4 position : SV_Position;
};

float4 main(PSInput input) : SV_Target
{
  // Normalized pixel coordinates (from 0 to 1)
  float2 uv = input.position.xy / iResolution.xy;
  uv -= 0.5;
  float2 res = abs(uv);
  float t = 1.0 - step(0.5, res.x + res.y);
  
  return float4(t, 0.0, 0.0, 1.0);
}
