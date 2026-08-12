# 07 · Cierre: cadena de custodia y discusión

**Dónde se ejecuta:** discusión en clase, sin comandos nuevos.

## Resumen de lo que se demostró

1. Acceso remoto **autorizado** (SSH con credenciales entregadas) — no explotación de vulnerabilidades.
2. Triage rápido de artefactos volátiles (procesos, red, usuarios) antes de un volcado pesado.
3. Adquisición completa de memoria con WinPmem, con verificación de hash antes y después de transferir.
4. Análisis del volcado con Volatility3 para reconstruir actividad del sistema.

## Cadena de custodia: por qué importa

Todo lo hecho en este taller, en un caso real, debería quedar documentado con:

- Quién ejecutó cada comando y cuándo (timestamps).
- Hash SHA256 del archivo en origen y en destino (hecho en el paso 05.4 y 05.6).
- Copia de los comandos exactos usados (por eso conviene guardar el historial de la sesión SSH).
- Justificación legal del acceso (orden judicial, contrato de pentest, política interna de la empresa, etc.).

Sin esta documentación, la evidencia técnica puede ser correcta pero no sirve en un proceso legal ni en un informe formal de incidente.

## Preguntas guía para la discusión

- ¿Qué hubiera pasado si transferíamos el volcado de memoria por un canal sin cifrar en vez de SSH/SCP?
- ¿Por qué priorizamos el triage rápido antes del volcado completo de RAM?
- ¿Qué diferencia hay entre este escenario (credenciales entregadas) y un escenario de pentest de caja negra?
- Si el volcado de memoria hubiera revelado datos personales de terceros no relacionados con el incidente, ¿qué implicaciones de privacidad tendría?

## Limitaciones de este taller (dejarlas explícitas a los estudiantes)

- No cubrimos adquisición de disco (imagen forense completa), solo memoria volátil.
- No cubrimos herramientas enterprise de recolección a escala (Velociraptor, GRR, KAPE) por tiempo, pero se mencionan como el siguiente paso natural.
- El entorno es un laboratorio controlado; en producción, la adquisición remota de memoria puede impactar el rendimiento del equipo objetivo y debe planificarse con el equipo de operaciones.

## Para profundizar (fuera de clase)

- Volatility3 docs: https://volatility3.readthedocs.io/
- SANS FOR508 (Advanced Incident Response, Threat Hunting, and Digital Forensics)
- Velociraptor (recolección remota a escala): https://docs.velociraptor.app/
