struct PSInput
{
  float4 position : SV_Position;
};

float4 main(PSInput input) : SV_Target 
{
  float t = step(200.0, input.position.x);
  return float4(1.0 - t, 0.0, 0.0, 1.0);
}
