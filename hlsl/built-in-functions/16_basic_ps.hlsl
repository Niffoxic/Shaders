cbuffer Uniforms : register(b0)
{
  float2 iResolution;
};

struct PSInput
{
  float4 position : SV_Position;
};

float ShouldBlackSide(float x)
{
  float left = step(50.0, x);
  float right = step(iResolution.x - 50, x);
  right = 1.0 - right;
  return step(2.0, left + right);
}

float ShouldBlackTop(float y)
{
  float down = step(50.0, y);
  float up = step(iResolution.y - 50, y);
  up = 1.0 - up;
  return step(2.0, down + up);
}

float4 main(PSInput input) : SV_Target
{
  // Normalized pixel coordinates (from 0 to 1)
  float2 uv = input.position.xy / iResolution.xy;
  float t = ShouldBlackSide(input.position.x);
  float y = ShouldBlackTop(input.position.y);
  float res = (2.0, t + y);
  float3 color = float3(uv, 0.0);
  float3 top = color - (color * y);
  float3 side = color - (color * t);
  return float4(max(top, side), 1.0);
}
