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

    float3 red   = float3(1.0, 0.0, 0.0);
    float3 black = float3(0.0, 0.0, 0.0);
    float3 blue  = float3(0.0, 0.0, 1.0);
    float3 green = float3(0.0, 1.0, 0.0);

    float3 x_1 = lerp(red, black, uv.x);
    float3 x_2 = lerp(blue, green, uv.x);

    return float4(lerp(x_1, x_2, uv.y), 1.0);
}
