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
  float x = input.position.x / iResolution.x;
  float t = step(0.5, x);
  return float4(t, 0.0, 0.0, 1.0);
}
