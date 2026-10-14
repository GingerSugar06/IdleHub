# Sürüm derlemesi: arayüz + işçi süreç + Python motoru, tek klasörde.
#   powershell -File tool/build.ps1
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

Write-Host '== 1/3 işçi derleniyor ==' -ForegroundColor Cyan
New-Item -ItemType Directory -Force build | Out-Null
Push-Location worker
dart pub get
dart compile exe bin/idle_worker.dart -o ../build/idle_worker.exe
Pop-Location
if (-not (Test-Path build/idle_worker.exe)) { throw 'işçi derlenemedi' }

Write-Host '== 2/3 arayüz derleniyor ==' -ForegroundColor Cyan
flutter build windows --release

Write-Host '== 3/3 paketleniyor ==' -ForegroundColor Cyan
$out = 'build/windows/x64/runner/Release'
Copy-Item build/idle_worker.exe $out -Force
New-Item -ItemType Directory -Force "$out/engine" | Out-Null
Copy-Item engine/engine.py, engine/requirements.txt "$out/engine" -Force

Write-Host ''
Write-Host "PAKET : $out" -ForegroundColor Green
Write-Host 'Çalıştır: idle_hub.exe'
