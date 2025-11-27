cbuffer Uniforms : register(b0)
{
  float2 iResolution;
};

struct PSInput
{
  float4 position : SV_Position;
};

float pattern(float2 uv)
{
  uv = uv * 2.0 - 1.0;
  float t = pow(uv.x * uv.x, 0.3) + pow(uv.y * uv.y, 0.3) - 1.0;
  return step(0.0, t) * t * 10.0 + step(0.2, t);
}

float4 main(PSInput input) : SV_Target
{
  // Normalized pixel coordinates (from 0 to 1)
  float2 uv = input.position.xy / iResolution.xy;
  float2 scaled_uv = frac(uv * float2(5.0, 3.0));
  return float4(pattern(scaled_uv), 0.0, 0.0, 1.0);
}
