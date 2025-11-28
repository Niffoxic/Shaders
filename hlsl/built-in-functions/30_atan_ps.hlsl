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
  float pi = 3.14;
  float t = 1.0 - step(0.5, distance(float2(0.0, 0.0), uv));
  float angle = atan2(uv.y, uv.x);
  
  float3 red = float3(1.0, 0.0, 0.0);
  float3 green = float3(0.0, 1.0, 0.0);
  float3 color = lerp(red, green, abs(angle) / pi);
  return float4((color) * t, 1.0);
}