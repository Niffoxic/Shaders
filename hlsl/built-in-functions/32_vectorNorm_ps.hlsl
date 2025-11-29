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
    float2 uv = input.position.xy / iResolution;

    float isLeft  = step(uv.x, 0.5);
    float isRight = 1.0 - isLeft;

    float2 leftOrigin  = float2(0.25, 0.5);
    float2 rightOrigin = float2(0.75, 0.5);

    float2 leftDir  = normalize(uv - leftOrigin);
    float2 rightDir = normalize(uv - rightOrigin);

    float cosVal = leftDir.x;
    float sinVal = rightDir.y;

    float value = isLeft * leftDir.x + isRight * rightDir.y;

    return float4(value, value, value, 1.0);
}
