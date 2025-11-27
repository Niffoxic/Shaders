float4 main() : SV_Target 
{
  float4 blueChannel = float4(0.0, 0.0, 0.75, 0.0);
  float4 redChannel = float4(0.5, 0.0, 0.0, 0.0);
  float4 alphaChannel = float4(0.0, 0.0, 0.0, 1.0);

  return blueChannel + redChannel + alphaChannel;
}
