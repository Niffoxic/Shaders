param(
    [string]$ScreenshotsDir = "screenshots",
    [string]$HlslDir        = "hlsl",
    [string]$OutputPath     = "docs/shaders.json"
)

Write-Host "=== Generating shader manifest ==="
Write-Host "ScreenshotsDir : $ScreenshotsDir"
Write-Host "HlslDir        : $HlslDir"
Write-Host "OutputPath     : $OutputPath"
Write-Host ""

$screensRoot = (Resolve-Path $ScreenshotsDir).Path
$hlslRoot    = (Resolve-Path $HlslDir).Path

Write-Host "Resolved paths:"
Write-Host "  ScreenshotsRoot: $screensRoot"
Write-Host "  HlslRoot       : $hlslRoot"
Write-Host ""

$imageExtensions = @("*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp")

$files = Get-ChildItem `
    -Path  $screensRoot `
    -File `
    -Recurse `
    -Include $imageExtensions

if ($files.Count -eq 0) {
    Write-Warning "No screenshot files found under $screensRoot"
}

$entries = @()

foreach ($file in $files) {
    $fullImagePath = $file.FullName

    $relativePath = $fullImagePath.Substring($screensRoot.Length).TrimStart('\','/')

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

    $imageWebPath  = "../screenshots/" + ($relativePath     -replace '\\','/')
    $shaderWebPath = "../hlsl/"        + ($hlslRelativePath -replace '\\','/')

    $groupName = if ([string]::IsNullOrEmpty($relativeDir)) {
        ""
    } else {
        $relativeDir -replace '\\','/'
    }

    $entry = [PSCustomObject]@{
        name   = $baseName
        group  = $groupName
        title  = $baseName
        image  = $imageWebPath
        shader = $shaderWebPath
    }

    $entries += $entry
}

$entries = $entries | Sort-Object group, name

$docsDir = Split-Path $OutputPath -Parent
if (-not (Test-Path $docsDir)) {
    New-Item -ItemType Directory -Path $docsDir | Out-Null
}

$entries | ConvertTo-Json -Depth 3 | Set-Content -Encoding UTF8 $OutputPath

Write-Host ""
Write-Host "Done. Wrote $($entries.Count) entries to $OutputPath"
