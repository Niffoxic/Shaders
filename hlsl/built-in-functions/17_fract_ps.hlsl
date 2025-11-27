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
  float x = uv.x * 10.0;
  float t = step(0.5, frac(x));
  float3 res = float3(1.0, 0.0, 0.0);
  return float4(t * res, 1.0);
}
