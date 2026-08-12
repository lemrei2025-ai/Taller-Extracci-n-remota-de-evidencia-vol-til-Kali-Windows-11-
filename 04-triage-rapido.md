# 04 · Demo 1: Triage rápido de evidencia volátil (sin volcar RAM)

**Dónde se ejecuta:** desde Kali, vía SSH hacia Windows 11.

Antes de un volcado completo de memoria (que toma tiempo y espacio), en un incidente real casi siempre se hace primero un **triage rápido**: una foto instantánea de procesos, conexiones de red y sesiones activas. Esto respeta el "orden de volatilidad" — capturar primero lo que cambia más rápido.

## 4.1 Ejecutar comandos puntuales por SSH

> ⚠️ **Por qué hay que invocar `powershell` explícitamente:** cuando conectas por SSH a Windows 11, el servidor OpenSSH ejecuta el comando remoto usando el *shell por defecto* configurado en el sistema, que **por defecto es `cmd.exe`**, no PowerShell. Como `Get-Process`, `Get-NetTCPConnection` y `Get-NetNeighbor` son *cmdlets* de PowerShell (no comandos de `cmd.exe`), si los envías tal cual el equipo remoto responde con un error del tipo `'Get-Process' is not recognized as an internal or external command`. Por eso cada comando debe envolverse con `powershell -Command "..."`, para forzar que sea PowerShell quien lo interprete.
>
> Alternativa (opcional, fuera del alcance de este taller): se puede configurar PowerShell como shell por defecto de OpenSSH en Windows con `New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force`. Si el profesor ya configuró esto en las VMs, los comandos funcionan sin el envoltorio `powershell -Command`, pero es más seguro y portable asumir que no está configurado y envolver siempre los comandos como se muestra abajo.

Desde Kali, sin necesidad de sesión interactiva, puedes lanzar comandos remotos uno a uno:

```bash
ssh labforense@192.168.56.20 "powershell -Command \"Get-Process | Sort-Object CPU -Descending | Select-Object -First 15\""
ssh labforense@192.168.56.20 "powershell -Command \"Get-NetTCPConnection -State Established\""
ssh labforense@192.168.56.20 "quser"
ssh labforense@192.168.56.20 "powershell -Command \"Get-NetNeighbor\""   # equivalente moderno de 'arp -a'
```

> 📌 Nota sobre `quser`: es un binario nativo de Windows (`quser.exe`), no un cmdlet de PowerShell, por lo que funciona igual lo ejecute `cmd.exe` o PowerShell — no necesita el envoltorio `powershell -Command`.

Cada comando te muestra, respectivamente: procesos activos, conexiones TCP establecidas, usuarios con sesión iniciada, y la tabla ARP (qué otros equipos ha "visto" la máquina en la red).

## 4.2 Correr el script de triage completo

En lugar de comandos sueltos, usamos el script preparado [`scripts/triage.ps1`](../scripts/triage.ps1), que junta todo en un solo archivo de salida con timestamp.

**Transferir el script a Windows 11 (desde Kali):**

```bash
scp scripts/triage.ps1 labforense@192.168.56.20:C:/Users/labforense/triage.ps1
```

**Ejecutarlo remotamente:**

```bash
ssh labforense@192.168.56.20 "powershell -ExecutionPolicy Bypass -File C:/Users/labforense/triage.ps1"
```

El script genera un archivo `triage_<fecha-hora>.txt` en el escritorio del usuario `labforense` con: procesos, conexiones TCP/UDP, usuarios conectados, tabla ARP, e información general del sistema (`systeminfo`).

## 4.3 Traer el resultado a Kali

```bash
scp labforense@192.168.56.20:C:/Users/labforense/Desktop/triage_*.txt ./evidencia/
```

> 📌 **Punto de discusión:** este triage por sí solo ya es evidencia volátil valiosa (qué procesos corrían, qué conexiones había) y se puede obtener en segundos, sin necesitar los ~2-8 GB que pesa un volcado completo de RAM. En muchos casos reales, con esto basta para decidir los siguientes pasos.

Siguiente paso: [05-adquisicion-memoria.md](05-adquisicion-memoria.md)
