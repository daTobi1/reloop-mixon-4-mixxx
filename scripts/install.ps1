# Kopiert das Reloop-Mixon-4-Mapping in den Mixxx-Controller-Ordner.
# Aufruf:  powershell -ExecutionPolicy Bypass -File scripts\install.ps1
# Danach Mixxx (neu) starten und den Controller unter
# Optionen -> Einstellungen -> Controller aktivieren.

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot "controllers"
$target = Join-Path $env:LOCALAPPDATA "Mixxx\controllers"

if (-not (Test-Path $source)) {
    throw "Quellordner nicht gefunden: $source"
}

New-Item -ItemType Directory -Force -Path $target | Out-Null

$files = Get-ChildItem -Path $source -Include "*.midi.xml", "*.scripts.js" -Recurse
if ($files.Count -eq 0) {
    throw "Keine Mapping-Dateien in $source gefunden."
}

foreach ($file in $files) {
    Copy-Item -Path $file.FullName -Destination $target -Force
    Write-Host "Kopiert: $($file.Name) -> $target"
}

Write-Host ""
Write-Host "Fertig. Mixxx neu starten, dann unter Einstellungen -> Controller"
Write-Host "'Reloop Mixon 4' fuer das MIDI-Geraet auswaehlen."
