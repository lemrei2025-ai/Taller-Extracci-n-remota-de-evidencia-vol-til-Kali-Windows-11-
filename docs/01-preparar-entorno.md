# 01 · Preparar el entorno (VirtualBox + red interna)

**Dónde se ejecuta:** en el equipo host (el portátil/PC de cada estudiante o del profesor).

## 1.1 Instalar VirtualBox

Descarga e instala VirtualBox 7.x desde https://www.virtualbox.org/. También instala el **Extension Pack** correspondiente (mejora el soporte de red y USB).

## 1.2 Crear una red interna aislada

Vamos a usar una red **host-only** (o "internal network") para que Kali y Windows 11 se vean entre sí, pero **sin salida a internet ni a la red del campus**. Esto es clave para el aviso legal del taller: todo el tráfico queda contenido en el laboratorio.

En VirtualBox:

1. `Archivo → Herramientas del host → Redes de red solo anfitrión` (Host Network Manager).
2. Clic en **Crear**. Se genera una red, por ejemplo `vboxnet0`.
3. Edítala y define el rango: `192.168.56.0/24`, con DHCP habilitado (o direcciones estáticas si prefieres controlarlas a mano).

Cada VM que conectemos a esta red host-only recibirá una IP dentro de `192.168.56.0/24` y no tendrá salida a internet — suficiente para SSH, WinRM, netcat y scp entre las dos VMs.

## 1.3 Descargar las imágenes

- **Kali Linux**: usa la VM preconstruida para VirtualBox desde https://www.kali.org/get-kali/ (sección "Virtual Machines") — evita instalar desde el ISO si el tiempo de clase es corto.
- **Windows 11**: usa una VM de evaluación oficial de Microsoft desde https://developer.microsoft.com/windows/downloads/virtual-machines/ (formato VirtualBox disponible). Estas VMs vienen con una licencia de evaluación de 90 días, ideal para laboratorio.

## 1.4 Snapshot inicial

Antes de tocar nada dentro de las VMs, apágalas e inmediatamente toma una **snapshot** de cada una (`Máquina → Tomar instantánea`). Así, si algo se rompe durante la demo, se puede restaurar en segundos en lugar de reinstalar.

Siguiente paso: [02-configurar-vms.md](02-configurar-vms.md)
