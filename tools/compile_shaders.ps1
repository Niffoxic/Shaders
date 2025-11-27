param
(
    [string]$Root = ".",
    [string]$EntryPoint = "main"
)

$ErrorActionPreference = "Stop"

Write-Host "HLSL Shader Compile Script"
Write-Host "Root: $Root"
Write-Host "Entry point: $EntryPoint"
Write-Host ""

# Find all .hlsl files under the root
$shaderFiles = Get-ChildItem -Path $Root -Recurse -Include *.hlsl

if (-not $shaderFiles)
{
    Write-Host "No .hlsl files found. Nothing to do."
    exit 0
}

# get profile from filename
function Get-ShaderProfile([string]$name)
{
    if     ($name -match "_vs\.hlsl$") { return "vs_6_0" }
    elseif ($name -match "_ps\.hlsl$") { return "ps_6_0" }
    elseif ($name -match "_cs\.hlsl$") { return "cs_6_0" }
    elseif ($name -match "_gs\.hlsl$") { return "gs_6_0" }
    elseif ($name -match "_hs\.hlsl$") { return "hs_6_0" }
    elseif ($name -match "_ds\.hlsl$") { return "ds_6_0" }
    else { return $null }
}

$overallExitCode = 0

foreach ($shader in $shaderFiles) 
{
    $profile = Get-ShaderProfile $shader.Name

    if (-not $profile) 
    {
        Write-Host "Skipping (unknown type): $($shader.FullName)"
        continue
    }

    # Output path - same folder with .cso extension
    $outPath = [System.IO.Path]::ChangeExtension($shader.FullName, ".cso")

    Write-Host "Compiling: $($shader.FullName)"
    Write-Host "  Profile: $profile"
    Write-Host "  Output : $outPath"

    # Call DXC
    & dxc.exe `
        -T $profile `
        -E $EntryPoint `
        -Fo $outPath `
        $shader.FullName

    if ($LASTEXITCODE -ne 0) 
    {
        Write-Error "Failed to compile: $($shader.FullName) (exit code $LASTEXITCODE)"
        $overallExitCode = 1
    }
    else 
    {
        Write-Host "  OK"
    }

    Write-Host ""
}

if ($overallExitCode -ne 0) 
{
    Write-Error "One or more shaders failed to compile."
}
else 
{
    Write-Host "All shaders compiled successfully."
}

exit $overallExitCode
