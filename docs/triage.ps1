<#
.SYNOPSIS
    Script de triage rapido de evidencia volatil para el taller Kali -> Windows 11.
    Se ejecuta EN Windows 11 (localmente o lanzado remotamente por SSH desde Kali).

.DESCRIPCION
    Recolecta procesos, conexiones de red, usuarios conectados, tabla ARP e
    informacion general del sistema, y lo guarda todo en un unico archivo de
    texto con timestamp en el Escritorio del usuario actual.

.USO
    powershell -ExecutionPolicy Bypass -File triage.ps1
#>

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outDir    = "$env:USERPROFILE\Desktop"
$outFile   = Join-Path $outDir "triage_$timestamp.txt"

function Write-Section {
    param([string]$Title)
    Add-Content -Path $outFile -Value "`n===== $Title ====="
}

Add-Content -Path $outFile -Value "Triage de evidencia volatil"
Add-Content -Path $outFile -Value "Host: $env:COMPUTERNAME"
Add-Content -Path $outFile -Value "Fecha/hora de captura: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Add-Content -Path $outFile -Value "Usuario que ejecuta: $env:USERNAME"

Write-Section "Procesos activos (ordenados por CPU)"
Get-Process | Sort-Object CPU -Descending |
    Select-Object -First 30 Id, ProcessName, CPU, StartTime |
    Format-Table -AutoSize | Out-String -Width 200 | Add-Content -Path $outFile

Write-Section "Conexiones TCP establecidas"
Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue |
    Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess |
    Format-Table -AutoSize | Out-String -Width 200 | Add-Content -Path $outFile

Write-Section "Endpoints UDP en escucha"
Get-NetUDPEndpoint -ErrorAction SilentlyContinue |
    Select-Object LocalAddress, LocalPort, OwningProcess |
    Format-Table -AutoSize | Out-String -Width 200 | Add-Content -Path $outFile

Write-Section "Usuarios con sesion iniciada"
quser 2>$null | Out-String | Add-Content -Path $outFile

Write-Section "Tabla ARP / vecinos de red"
Get-NetNeighbor -ErrorAction SilentlyContinue |
    Select-Object IPAddress, LinkLayerAddress, State |
    Format-Table -AutoSize | Out-String -Width 200 | Add-Content -Path $outFile

Write-Section "Informacion general del sistema"
systeminfo | Out-String | Add-Content -Path $outFile

Write-Host "Triage completado: $outFile"
