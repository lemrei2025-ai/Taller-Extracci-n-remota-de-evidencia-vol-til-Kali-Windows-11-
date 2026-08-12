# 05 · Demo 2: Adquisición remota de memoria completa (WinPmem)

**Dónde se ejecuta:** WinPmem corre en Windows 11 (lanzado remotamente desde Kali por SSH), el volcado se transfiere a Kali.

> **Antes de empezar — direcciones IP:** Las IP `192.168.56.20` (Windows 11) y `192.168.56.10` (Kali) que aparecen en esta guía son solo un ejemplo, correspondiente a una red interna/Host-Only típica de VirtualBox (rango `192.168.56.0/24`). **La IP real depende de la red LAN de cada laboratorio** (adaptador Host-Only, red interna, NAT con reenvío de puertos, red puente/bridge o una LAN física distinta), así que puede cambiar entre equipos, entre sesiones de clase, o si la VM recibe una IP por DHCP.
>
> Verifica siempre las IP reales antes de ejecutar los comandos:
> - En Kali: `ip a` o `hostname -I`
> - En Windows 11 (PowerShell o CMD): `ipconfig`
>
> Para no tener que cambiar cada comando a mano, guarda las IP reales en variables y reutilízalas:
>
> ```bash
> IP_WIN=192.168.56.20      # IP real de la VM Windows 11 en tu red
> IP_KALI=192.168.56.10     # IP real de tu Kali en la misma red
> ```
>
> Los comandos de esta guía usan `$IP_WIN` y `$IP_KALI`; si prefieres no usar variables, simplemente sustitúyelas por las IP reales de tu red. Si Windows y Kali quedan en segmentos distintos (por ejemplo, una LAN física con varios switches/VLANs) o hay un firewall de por medio, confirma también que el puerto usado por `ncat` (4444) y el puerto SSH (22) estén accesibles entre las dos máquinas.

## 5.1 Descargar WinPmem

En el host (o directamente en Kali con `wget`), descarga la última release firmada desde el repositorio oficial:

```bash
wget https://github.com/Velocidex/WinPmem/releases/latest/download/winpmem_mini_x64_rc2.exe -O winpmem.exe
```

> Usa siempre la versión más reciente del release oficial: el driver viene firmado digitalmente, así que normalmente **no** hace falta desactivar Secure Boot en la VM. Si Windows llegara a bloquear el driver, desactiva Secure Boot solo dentro de esta VM de laboratorio (nunca en un equipo real de producción).

## 5.2 Copiar WinPmem a Windows 11

```bash
scp winpmem.exe labforense@$IP_WIN:C:/Users/labforense/winpmem.exe
```

## 5.3 Ejecutar el volcado de memoria remotamente

```bash
ssh labforense@$IP_WIN "C:/Users/labforense/winpmem.exe C:/Users/labforense/memoria.raw"
```

Esto puede tardar 1-3 minutos según la RAM asignada a la VM (recomendado asignar solo 2-4 GB a la VM de Windows 11 para que la demo en clase sea rápida).

## 5.4 Calcular el hash antes de transferir (cadena de custodia)

```bash
ssh prueba@IP_WIN powershell.exe -NoProfile -Command "Get-FileHash -Path 'C:\temp\memoria.raw' -Algorithm SHA256"
```

Anota este hash — es la prueba de integridad del archivo original.

## 5.5 Transferir el volcado a Kali

**Opción A — scp (más simple):**

```bash
scp labforense@$IP_WIN:C:/Users/labforense/memoria.raw ./evidencia/memoria.raw
```

**Opción B — netcat (para mostrar la alternativa "sin credenciales de archivo", solo streaming):**

En Kali, primero levanta el receptor con el script de apoyo:

```bash
./scripts/recibir_dump.sh ./evidencia/memoria.raw
```

Y en Windows (por SSH), envía el archivo por el puerto que abrió el script, apuntando a la IP real de Kali:

```bash
ssh labforense@$IP_WIN "type C:/Users/labforense/memoria.raw | ncat $IP_KALI 4444"
```

## 5.6 Verificar integridad en Kali

```bash
sha256sum ./evidencia/memoria.raw
```

Compara este hash con el obtenido en el paso 5.4 — deben coincidir exactamente. Si no coinciden, el archivo se corrompió en la transferencia y no debería usarse como evidencia.

Siguiente paso: [06-analisis-volatility3.md](06-analisis-volatility3.md)
