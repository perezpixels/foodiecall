# Build React landing + Flutter kitchen webapp into ./preview and serve on :7357
# Flow: http://localhost:7357/  → React landing
#       http://localhost:7357/app/ → Flutter onboarding → portal

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path "$root\web\package.json")) { $root = "C:\Users\salem\.cursor\Foodiecall" }

$env:Path = "C:\dev\flutter\bin;C:\Program Files\Git\bin;" + $env:Path
Set-Location $root

if (Test-Path "$root\preview") {
  Remove-Item "$root\preview" -Recurse -Force
}

Write-Host "Building React landing → preview/" -ForegroundColor Cyan
Set-Location "$root\web"
$env:VITE_BASE = "/"
npm run build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Building Flutter kitchen → preview/app/" -ForegroundColor Cyan
Set-Location "$root\admin"
flutter pub get
$appOut = Join-Path $root "preview\app"
flutter build web --release --base-href "/app/" --output="$appOut"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Get-NetTCPConnection -LocalPort 7357 -ErrorAction SilentlyContinue | ForEach-Object {
  Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 1

Write-Host "Serving preview at http://localhost:7357" -ForegroundColor Green
Set-Location $root
npx --yes serve preview -l 7357
