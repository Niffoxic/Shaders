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
  float2 color = input.position.xy / iResolution;
    return float4(color, 0.0, 1.0);
}
