# Taller: Extracción remota de evidencia volátil (Kali → Windows 11)

Taller demo de 1-2 horas, nivel introductorio, para clase de forense digital / respuesta a incidentes (DFIR). Los estudiantes aprenden a recolectar y analizar evidencia volátil (procesos, conexiones de red, memoria RAM) de una máquina Windows 11 desde una máquina Kali Linux, usando un laboratorio 100% aislado y de su propiedad.

## ⚠️ Aviso legal y ético (leer antes de empezar)

- Este taller se ejecuta **exclusivamente** dentro de un laboratorio virtual aislado, con dos máquinas virtuales propias, en una red interna sin salida a redes de producción ni a internet de terceros.
- Nunca se debe ejecutar ninguno de estos pasos contra un equipo que no sea de tu propiedad o sobre el que no tengas autorización explícita por escrito. Acceder o extraer datos de un dispositivo ajeno sin consentimiento es un delito en la mayoría de países.
- El objetivo pedagógico es que el estudiante entienda **el flujo técnico** (acceso autorizado → recolección → cadena de custodia → análisis), no "hackear" nada.
- Antes de la clase, el profesor debe confirmar que ambas VMs corren en una red host-only/interna, sin acceso a la red del campus ni a internet.

## Objetivos de aprendizaje

Al finalizar, el estudiante podrá explicar y ejecutar:

1. Por qué la evidencia volátil se pierde al apagar un equipo y cuándo priorizar su captura.
2. Cómo establecer un canal de acceso remoto autorizado (SSH) hacia un Windows 11.
3. Cómo hacer triage rápido (procesos, conexiones, usuarios) sin volcar toda la memoria.
4. Cómo adquirir un volcado completo de RAM de forma remota con WinPmem.
5. Cómo analizar ese volcado con Volatility3 en Kali para encontrar procesos y conexiones de red.

## Requisitos previos

**Software (todo gratuito):**

- [VirtualBox](https://www.virtualbox.org/) 7.x (o VMware Workstation/Player si lo prefieres)
- ISO de [Kali Linux](https://www.kali.org/get-kali/) (imagen "Installer" o VM preconstruida)
- ISO de Windows 11 (Microsoft ofrece [VMs de evaluación](https://developer.microsoft.com/windows/downloads/virtual-machines/) listas para VirtualBox/VMware — evita instalar desde cero si el tiempo es corto)
- [WinPmem](https://github.com/Velocidex/WinPmem/releases) (binario firmado, última release)
- [Volatility3](https://github.com/volatilityfoundation/volatility3) (se instala con `pip` dentro de Kali)

**Hardware mínimo:** equipo host con 8 GB RAM (4 GB para el host + 2 GB por VM) y virtualización (VT-x/AMD-V) habilitada en BIOS.

## Agenda sugerida (90-120 min)

| Tiempo | Bloque | Documento |
|---|---|---|
| 15 min | Introducción: qué es evidencia volátil, orden de volatilidad, marco legal | (charla, sin doc) |
| 20 min | Preparar entorno: VirtualBox + red interna | [docs/01-preparar-entorno.md](docs/01-preparar-entorno.md) |
| 15 min | Configurar las dos VMs (Kali + Windows 11) | [docs/02-configurar-vms.md](docs/02-configurar-vms.md) |
| 10 min | Habilitar acceso remoto autorizado (SSH en Windows 11) | [docs/03-acceso-remoto-autorizado.md](docs/03-acceso-remoto-autorizado.md) |
| 15 min | Demo 1: triage rápido vía SSH | [docs/04-triage-rapido.md](docs/04-triage-rapido.md) |
| 20 min | Demo 2: volcado completo de memoria con WinPmem | [docs/05-adquisicion-memoria.md](docs/05-adquisicion-memoria.md) |
| 20 min | Demo 3: análisis del volcado con Volatility3 | [docs/06-analisis-volatility3.md](docs/06-analisis-volatility3.md) |
| 10 min | Cierre: cadena de custodia, limitaciones, preguntas | [docs/07-cierre-discusion.md](docs/07-cierre-discusion.md) |

Si la sesión es de 1 hora en vez de 2, el profesor puede saltar la instalación de las VMs (docs/01 y 02) y entregarlas ya preparadas, empezando directo en docs/03.

## Estructura del repo

```
taller-forense-volatil-kali-win11/
├── README.md                        # este archivo
├── docs/
│   ├── 01-preparar-entorno.md       # VirtualBox + red interna
│   ├── 02-configurar-vms.md         # instalar/importar Kali y Windows 11
│   ├── 03-acceso-remoto-autorizado.md  # habilitar SSH en Windows 11
│   ├── 04-triage-rapido.md          # procesos, red, usuarios sin volcar RAM
│   ├── 05-adquisicion-memoria.md    # volcado completo con WinPmem
│   ├── 06-analisis-volatility3.md   # análisis del .raw en Kali
│   └── 07-cierre-discusion.md       # cadena de custodia y preguntas guía
└── scripts/
    ├── triage.ps1                   # se ejecuta en Windows 11 vía SSH
    └── recibir_dump.sh              # receptor netcat en Kali (alternativa a scp)
```

## Cómo usar este repo

```bash
git clone <url-del-repo>
cd taller-forense-volatil-kali-win11
```

Sigue los documentos de `docs/` en orden, del 01 al 07. Cada uno indica en qué VM (Kali o Windows 11) se ejecuta cada comando.
