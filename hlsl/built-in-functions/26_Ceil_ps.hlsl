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
  float strength = ceil(uv * 10.0) / 10.0;
  return float4(strength, 0.0, 0.0, 1.0);
}
