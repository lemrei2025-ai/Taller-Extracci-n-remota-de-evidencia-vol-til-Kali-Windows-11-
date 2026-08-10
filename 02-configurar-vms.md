# 02 · Configurar las VMs (Kali + Windows 11)

**Dónde se ejecuta:** en el equipo host, configurando cada VM.

## 2.1 Importar y conectar ambas VMs a la red interna

Para **cada** VM (Kali y Windows 11):

1. `Configuración → Red → Adaptador 1`.
2. "Conectado a": **Adaptador solo-anfitrión** (Host-only Adapter).
3. Nombre: la red que creaste en el paso 01.3 (`vboxnet0`).

Enciende ambas VMs.

## 2.2 Verificar conectividad

**En Kali** (terminal):

```bash
ip a          # confirma que tienes una IP en 192.168.56.0/24
```

**En Windows 11** (PowerShell):

```powershell
ipconfig      # confirma la IP en el mismo rango
```

Anota las dos IPs, por ejemplo:

- Kali: `192.168.56.10`
- Windows 11: `192.168.56.20`

Desde Kali, confirma que ves a Windows:

```bash
ping 192.168.56.20
```

> Si Windows no responde al ping, es normal: el Firewall de Windows bloquea ICMP por defecto. No es un problema, lo resolveremos al habilitar SSH en el siguiente documento.

## 2.3 Actualizar Kali (opcional si hay tiempo)

```bash
sudo apt update && sudo apt -y install openssh-client netcat-traditional python3-pip
```

## 2.4 Crear el usuario de laboratorio en Windows 11

Para que la demo simule un escenario realista (acceso con **credenciales autorizadas**, no una intrusión), crea un usuario administrador dedicado al taller:

**PowerShell (como Administrador) en Windows 11:**

```powershell
net user labforense "Taller#2026!" /add
net localgroup administradores labforense /add
```

Este usuario `labforense` es el que Kali usará para conectarse — representa, por ejemplo, a un analista de IR con credenciales entregadas por la empresa dueña del equipo.

Siguiente paso: [03-acceso-remoto-autorizado.md](03-acceso-remoto-autorizado.md)
