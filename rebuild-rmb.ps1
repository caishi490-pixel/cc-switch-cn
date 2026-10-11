# Rebuild the CNY-modified cc-switch and deploy to the installed app.
# Optional: set $env:VITE_CC_RMB_RATE before running to change the CNY rate (default 7.2).
$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
$install = Join-Path $env:LOCALAPPDATA 'Programs\CC Switch'

$env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"
$env:HTTP_PROXY = 'http://127.0.0.1:7897'
$env:HTTPS_PROXY = 'http://127.0.0.1:7897'

Set-Location $repo
pnpm tauri build --no-bundle

$built = Join-Path $repo 'src-tauri\target\release\cc-switch.exe'
if (-not (Test-Path -LiteralPath $built)) { throw 'build output missing: ' + $built }

Stop-Process -Name cc-switch -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Copy-Item -LiteralPath $built -Destination (Join-Path $install 'cc-switch.exe') -Force
Start-Process -FilePath (Join-Path $install 'cc-switch.exe')
Write-Output 'Done. CC Switch restarted with the CNY build.'
