#!/usr/bin/env bash
#
# recibir_dump.sh — Receptor netcat para el taller Kali -> Windows 11.
# Se ejecuta EN KALI. Levanta un listener en el puerto 4444 y guarda todo
# lo que reciba en el archivo indicado. Es la alternativa a "scp" para
# demostrar transferencia de un volcado de memoria vía streaming.
#
# Uso:
#   ./recibir_dump.sh ./evidencia/memoria.raw [puerto]
#
# Luego, desde Windows 11 (por SSH), enviar el archivo con:
#   type C:\Users\labforense\memoria.raw | ncat <IP_DE_KALI> 4444
#
# Requiere: ncat (paquete nmap-ncat) o netcat-traditional.

set -euo pipefail

DEST="${1:?Uso: $0 <archivo_destino> [puerto]}"
PORT="${2:-4444}"

mkdir -p "$(dirname "$DEST")"

echo "[*] Escuchando en el puerto $PORT..."
echo "[*] El volcado recibido se guardará en: $DEST"
echo "[*] Presiona Ctrl+C para cancelar."

if command -v ncat >/dev/null 2>&1; then
    ncat -l -p "$PORT" > "$DEST"
elif command -v nc >/dev/null 2>&1; then
    nc -l -p "$PORT" > "$DEST"
else
    echo "Error: no se encontró 'ncat' ni 'nc'. Instala con: sudo apt install ncat" >&2
    exit 1
fi

echo "[*] Transferencia finalizada."
echo "[*] Verifica integridad con: sha256sum \"$DEST\""
