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
  float2 uv = input.position.xy / iResolution.xy;
  float3 color = float3(1.0, 0.3, 0.3);

  float left = step(0.25, uv.x);
  float right = step(0.75, uv.x);
  float3 mask = float3(-1.0, -0.7, -0.7);
  
  float3 left_color = color + (left * mask);
  float3 right_color = color + ((1.0 - right) * mask);
  
  return float4(max(left_color, right_color), 1.0);
}
