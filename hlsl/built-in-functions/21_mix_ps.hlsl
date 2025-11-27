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
  float t = step(0.25, uv.x);
  float influence = ((uv.x - 0.25) / 0.75) * t;

  float3 color2 = float3(0.38, 0.12, 0.93);
  float3 color1 = float3(1.00, 0.30, 0.30);

  return float4(lerp(color1, color2, influence), 1.0);
}
