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
  
  float2 uv = (input.position.xy - 0.5 * iResolution) / iResolution.y;
  float t = 1.0 - step(0.25, distance(float2(0.0, 0.0), uv));
  return float4(t, 0.0, 0.0, 1.0);
}
