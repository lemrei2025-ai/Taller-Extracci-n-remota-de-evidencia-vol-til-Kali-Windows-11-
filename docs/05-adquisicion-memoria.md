# 05 · Demo 2: Adquisición remota de memoria completa (WinPmem)

**Dónde se ejecuta:** WinPmem corre en Windows 11 (lanzado remotamente desde Kali por SSH), el volcado se transfiere a Kali.

## 5.1 Descargar WinPmem

En el host (o directamente en Kali con `wget`), descarga la última release firmada desde el repositorio oficial:

```bash
wget https://github.com/Velocidex/WinPmem/releases/latest/download/winpmem_mini_x64_rc2.exe -O winpmem.exe
```

> Usa siempre la versión más reciente del release oficial: el driver viene firmado digitalmente, así que normalmente **no** hace falta desactivar Secure Boot en la VM. Si Windows llegara a bloquear el driver, desactiva Secure Boot solo dentro de esta VM de laboratorio (nunca en un equipo real de producción).

## 5.2 Copiar WinPmem a Windows 11

```bash
scp winpmem.exe labforense@192.168.56.20:C:/Users/labforense/winpmem.exe
```

## 5.3 Ejecutar el volcado de memoria remotamente

```bash
ssh labforense@192.168.56.20 "C:/Users/labforense/winpmem.exe C:/Users/labforense/memoria.raw"
```

Esto puede tardar 1-3 minutos según la RAM asignada a la VM (recomendado asignar solo 2-4 GB a la VM de Windows 11 para que la demo en clase sea rápida).

## 5.4 Calcular el hash antes de transferir (cadena de custodia)

```bash
ssh labforense@192.168.56.20 "Get-FileHash C:/Users/labforense/memoria.raw -Algorithm SHA256"
```

Anota este hash — es la prueba de integridad del archivo original.

## 5.5 Transferir el volcado a Kali

**Opción A — scp (más simple):**

```bash
scp labforense@192.168.56.20:C:/Users/labforense/memoria.raw ./evidencia/memoria.raw
```

**Opción B — netcat (para mostrar la alternativa "sin credenciales de archivo", solo streaming):**

En Kali, primero levanta el receptor con el script de apoyo:

```bash
./scripts/recibir_dump.sh ./evidencia/memoria.raw
```

Y en Windows (por SSH), envía el archivo por el puerto que abrió el script:

```bash
ssh labforense@192.168.56.20 "type C:/Users/labforense/memoria.raw | ncat 192.168.56.10 4444"
```

## 5.6 Verificar integridad en Kali

```bash
sha256sum ./evidencia/memoria.raw
```

Compara este hash con el obtenido en el paso 5.4 — deben coincidir exactamente. Si no coinciden, el archivo se corrompió en la transferencia y no debería usarse como evidencia.

Siguiente paso: [06-analisis-volatility3.md](06-analisis-volatility3.md)
