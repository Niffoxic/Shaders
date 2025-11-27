param(
    [string]$Root = "hlsl",
    [string]$EntryPoint = "main"
)

Write-Host "HLSL Shader Compile Script"
Write-Host "Root: $Root"
Write-Host "Entry point: $EntryPoint"
Write-Host ""

$rootPath = (Resolve-Path $Root).Path

$shaders = Get-ChildItem -Path $rootPath -Recurse -File -Include *.hlsl

if (-not $shaders -or $shaders.Count -eq 0) {
    Write-Warning "No .hlsl files found under $rootPath"
    exit 0
}

foreach ($shader in $shaders) {
    $inPath  = $shader.FullName
    $base    = $shader.BaseName
    $outPath = [System.IO.Path]::ChangeExtension($inPath, ".cso")

    $profile = "ps_6_0"
    if ($base -match "_vs$") { $profile = "vs_6_0" }
    elseif ($base -match "_cs$") { $profile = "cs_6_0" }

    Write-Host "Compiling: $inPath"
    Write-Host "  Profile: $profile"
    Write-Host "  Output : $outPath"

    dxc `
        -T $profile `
        -E $EntryPoint `
        -Fo $outPath `
        $inPath

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to compile: $inPath"
        exit 1
    }

    Write-Host "  OK"
    Write-Host ""
}

Write-Host "All shaders compiled successfully."
