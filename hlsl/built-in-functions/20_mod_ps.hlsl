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

  uv *= 9.0;
  float x = frac(uv.x);
  x = step(0.5, x);
  float t = step(1.0, fmod(uv.x + 1.0, 3.0));

  return float4(x * t, 0.0, 0.0, 1.0);
}
