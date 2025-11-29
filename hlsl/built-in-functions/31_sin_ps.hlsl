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
    float2 uv   = (input.position.xy - 0.5 * iResolution) / iResolution.y;
    float r     = length(uv);
    float angle = r * 5.0 * 2.0 * 3.14;
    float t     = (sin(angle) + 1.0) * 0.5;
    return float4(t, 0.0, 0.0, 1.0);
}
