# 03 · Habilitar acceso remoto autorizado en Windows 11

**Dónde se ejecuta:** en Windows 11 (habilitar), luego desde Kali (verificar).

Usamos **OpenSSH Server**, que viene integrado en Windows 11 como función opcional. Es el equivalente a que un administrador/IR responder ya tenga credenciales legítimas para conectarse — el punto de partida realista de cualquier adquisición remota.

## 3.1 Instalar OpenSSH Server

**PowerShell (como Administrador) en Windows 11:**

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

## 3.2 Iniciar el servicio y dejarlo automático

```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
```

## 3.3 Permitir el puerto 22 en el Firewall de Windows

```powershell
New-NetFirewallRule -Name sshd -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

## 3.4 Conectarse desde Kali

**En Kali:**

```bash
ssh labforense@192.168.56.20
```

Acepta el fingerprint la primera vez (`yes`) e ingresa la contraseña definida en el paso 02.4. Si ves un prompt de PowerShell de Windows, el acceso remoto autorizado quedó funcionando.

```
PS C:\Users\labforense>
```

> 📌 **Punto de discusión para la clase:** en un caso real, este acceso puede venir de credenciales entregadas por el cliente, de un agente EDR/DFIR ya desplegado (Velociraptor, GRR), o de acceso administrativo del propio dueño del equipo. Nunca de una vulnerabilidad explotada sin autorización — eso sería un escenario de intrusión, no de respuesta a incidentes.

Siguiente paso: [04-triage-rapido.md](04-triage-rapido.md)
