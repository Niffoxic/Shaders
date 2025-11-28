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
  int at = int(floor(uv.x * 4.0));
  float3 palette[5] = 
  {
    float3(1.0, 0.0, 0.0),
    float3(0.0, 1.0, 0.0),
    float3(0.0, 0.0, 1.0),
    float3(1.0, 1.0, 0.0),
    float3(0.0, 0.0, 0.0),
  };
  float str = (uv.x * 4.0) - at;
  return float4(lerp(palette[at], palette[min(at + 1, 4)], str), 1.0);
}
