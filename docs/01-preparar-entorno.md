# 01 · Preparar el entorno (VirtualBox + red interna)

**Dónde se ejecuta:** en el equipo host (el portátil/PC de cada estudiante o del profesor).

## 1.1 Instalar VirtualBox

Descarga e instala VirtualBox 7.x desde https://www.virtualbox.org/. También instala el **Extension Pack** correspondiente (mejora el soporte de red y USB).

## 1.2 Configurar dos adaptadores de red por VM (host-only + puente)

> ⚠️ **Por qué dos adaptadores y no uno solo:** si usas *únicamente* una red host-only, las VMs quedan completamente aisladas — sin salida a internet — por lo que no vas a poder correr `apt update`/`apt upgrade` en Kali ni descargar Volatility3, WinPmem, etc. Por eso cada VM lleva un **segundo adaptador en modo puente (Bridged)**, que le da salida real a internet usando la tarjeta de red del equipo host.
>
> - **Adaptador 1 — Host-only (`vboxnet0`):** es el que se usa para *todo* el ejercicio forense (SSH, scp, triage, volcado de memoria). Su rango (`192.168.56.0/24`) lo define VirtualBox y es completamente independiente de la red del host — no importa si el portátil está en el Wi-Fi de la casa, el de la universidad o un hotspot del celular, la IP dentro de `192.168.56.0/24` **no cambia**. Todos los comandos e IPs del taller (`192.168.56.20`, etc.) se refieren siempre a este adaptador.
> - **Adaptador 2 — Puente (Bridged):** solo se usa para tener internet y actualizar/descargar herramientas. Esta interfaz sí recibe una IP de la red LAN/Wi-Fi a la que esté conectado el portátil en ese momento (por lo tanto cambia de un sitio a otro), pero **eso no afecta nada del taller**, porque ningún comando de las demos apunta a esta IP — solo se usa de fondo para salir a internet.
>
> 📌 Nota: a diferencia de NAT, el modo puente conecta la VM directamente a la red física del host, por lo que mientras el Adaptador 2 esté activo la VM es visible para otros equipos de esa misma red (no solo para salir a internet). Si el taller se dicta en una red institucional con restricciones sobre qué equipos se pueden conectar, vale la pena confirmarlo con el área de TI antes de la sesión.

### 1.2.1 Crear la red host-only

En VirtualBox:

1. `Archivo → Herramientas del host → Redes de red solo anfitrión` (Host Network Manager).
2. Clic en **Crear**. Se genera una red, por ejemplo `vboxnet0`.
3. Edítala y define el rango: `192.168.56.0/24`, con DHCP habilitado (o direcciones estáticas si prefieres controlarlas a mano).

### 1.2.2 Asignar los dos adaptadores a cada VM

Con la VM apagada, entra a `Configuración → Red`:

- **Adaptador 1:** habilitado, conectado a **Red solo-anfitrión**, seleccionando `vboxnet0`.
- **Adaptador 2:** habilitado, conectado a **Adaptador puente**, seleccionando la interfaz de red física activa del host (Wi-Fi o Ethernet).

Repite esto tanto en la VM de Kali como en la de Windows 11. Cada VM quedará entonces con dos interfaces de red: una fija para el laboratorio (`192.168.56.0/24`) y otra para salir a internet.

> 📌 **Verificación rápida:** dentro de Kali, `ip a` debe mostrar dos interfaces con IP (una `192.168.56.x` fija y otra asignada por la red local, que puede variar). En Windows 11, `ipconfig` debe mostrar lo mismo en dos adaptadores Ethernet distintos. Si `apt update` sigue sin funcionar, revisa que el Adaptador 2 quede en **Puente** (no en "No conectado") y que la VM se haya reiniciado tras el cambio.

## 1.3 Descargar las imágenes

- **Kali Linux**: usa la VM preconstruida para VirtualBox desde https://www.kali.org/get-kali/ (sección "Virtual Machines") — evita instalar desde el ISO si el tiempo de clase es corto.
- **Windows 11**: usa una VM de evaluación oficial de Microsoft desde https://developer.microsoft.com/windows/downloads/virtual-machines/ (formato VirtualBox disponible). Estas VMs vienen con una licencia de evaluación de 90 días, ideal para laboratorio.

## 1.4 Actualizar el sistema e instalar herramientas

Con los dos adaptadores ya configurados, aprovecha la salida a internet del Adaptador 2 (puente) para dejar todo listo:

- En Kali: `sudo apt update && sudo apt upgrade -y`, y la instalación de Volatility3 (`pip install volatility3`, según se detalla en [06-analisis-volatility3.md](06-analisis-volatility3.md)).
- En Windows 11: descarga el binario de [WinPmem](https://github.com/Velocidex/WinPmem/releases) que se usará en la [adquisición de memoria](05-adquisicion-memoria.md).

Siguiente paso: [02-configurar-vms.md](02-configurar-vms.md)
