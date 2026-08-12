# 06 · Demo 3: Análisis del volcado con Volatility3

**Dónde se ejecuta:** en Kali, sobre el archivo `memoria.raw` ya transferido.

## 6.1 Instalar Volatility3

```bash
pip install volatility3 --break-system-packages
```

(O clona el repo si prefieres la versión de desarrollo: `git clone https://github.com/volatilityfoundation/volatility3.git`)

## 6.2 Listar procesos

```bash
vol -f ./evidencia/memoria.raw windows.pslist
```

Muestra los procesos que estaban activos en el momento del volcado, con su PID, PPID y horas de creación.

## 6.3 Ver el árbol de procesos

```bash
vol -f ./evidencia/memoria.raw windows.pstree
```

Útil para detectar procesos "hijos" sospechosos colgando de procesos legítimos (por ejemplo, un `powershell.exe` lanzado desde `winword.exe`).

## 6.4 Conexiones de red vistas en memoria

```bash
vol -f ./evidencia/memoria.raw windows.netscan
```

Muestra sockets y conexiones (incluidas algunas ya cerradas que seguían en memoria) — a menudo revela más que un `netstat` en vivo.

## 6.5 Línea de comandos con la que se lanzó cada proceso

```bash
vol -f ./evidencia/memoria.raw windows.cmdline
```

Muy útil para ver, por ejemplo, si un proceso se lanzó con parámetros ofuscados o sospechosos.

## 6.6 Ejercicio para la clase

Antes de la demo, el profesor puede abrir manualmente en el Windows 11 un par de procesos "de prueba" (por ejemplo, un `notepad.exe` con un documento abierto, y una conexión de red con `curl`/navegador a una IP conocida) para que los estudiantes los "encuentren" en el análisis de Volatility3 — refuerza el concepto de que la memoria retiene evidencia que el disco no.

Siguiente paso: [07-cierre-discusion.md](07-cierre-discusion.md)
