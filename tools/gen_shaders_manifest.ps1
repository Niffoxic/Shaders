param(
    [string]$ScreenshotsDir = "screenshots",
    [string]$HlslDir        = "hlsl",
    [string]$OutputPath     = "shaders.json"
)

Write-Host "=== Generating shader manifest ==="
Write-Host "ScreenshotsDir : $ScreenshotsDir"
Write-Host "HlslDir        : $HlslDir"
Write-Host "OutputPath     : $OutputPath"
Write-Host ""

$screensRoot = (Resolve-Path $ScreenshotsDir).ProviderPath
$hlslRoot    = (Resolve-Path $HlslDir).ProviderPath

Write-Host "Resolved paths:"
Write-Host "  ScreenshotsRoot: $screensRoot"
Write-Host "  HlslRoot       : $hlslRoot"
Write-Host ""

$imageExtensions = @("*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp")

$files = Get-ChildItem -Path $screensRoot -File -Recurse -Include $imageExtensions -ErrorAction SilentlyContinue

if (-not $files -or $files.Count -eq 0) {
    Write-Warning "No screenshot files found under $screensRoot"
}

$entries = New-Object System.Collections.Generic.List[Object]

foreach ($file in $files) {

    $relativePath = $file.FullName.Substring($screensRoot.Length).TrimStart('\','/')
    $relativeDir  = Split-Path $relativePath -Parent
    $baseName     = $file.BaseName

    if ([string]::IsNullOrEmpty($relativeDir)) {
        $hlslRelativePath = "$baseName.hlsl"
    } else {
        $hlslRelativePath = Join-Path $relativeDir "$baseName.hlsl"
    }

    $hlslFullPath = Join-Path $hlslRoot $hlslRelativePath

    if (-not (Test-Path $hlslFullPath)) {
        Write-Warning "No matching HLSL for screenshot: $relativePath (expected: $hlslFullPath)"
    }

    $imageWebPath  = "screenshots/" + ($relativePath     -replace '\\','/')
    $shaderWebPath = "hlsl/"        + ($hlslRelativePath -replace '\\','/')

    $groupName = if ([string]::IsNullOrEmpty($relativeDir)) { "" } else { $relativeDir -replace '\\','/' }

    $entry = [PSCustomObject]@{
        name   = $baseName
        group  = $groupName
        title  = $baseName
        image  = $imageWebPath
        shader = $shaderWebPath
    }

    $entries.Add($entry)
}

$targetDir = Split-Path $OutputPath -Parent
if ($targetDir -and -not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

$entries.ToArray() | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $OutputPath

Write-Host ""
Write-Host "Done. Wrote $($entries.Count) entries to $OutputPath"
