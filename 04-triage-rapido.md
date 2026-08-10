# 04 · Demo 1: Triage rápido de evidencia volátil (sin volcar RAM)

**Dónde se ejecuta:** desde Kali, vía SSH hacia Windows 11.

Antes de un volcado completo de memoria (que toma tiempo y espacio), en un incidente real casi siempre se hace primero un **triage rápido**: una foto instantánea de procesos, conexiones de red y sesiones activas. Esto respeta el "orden de volatilidad" — capturar primero lo que cambia más rápido.

## 4.1 Ejecutar comandos puntuales por SSH

Desde Kali, sin necesidad de sesión interactiva, puedes lanzar comandos remotos uno a uno:

```bash
ssh labforense@192.168.56.20 "Get-Process | Sort-Object CPU -Descending | Select-Object -First 15"
ssh labforense@192.168.56.20 "Get-NetTCPConnection -State Established"
ssh labforense@192.168.56.20 "quser"
ssh labforense@192.168.56.20 "Get-NetNeighbor"   # equivalente moderno de 'arp -a'
```

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
