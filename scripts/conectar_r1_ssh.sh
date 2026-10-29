#!/bin/sh
# Cisco AAA & RADIUS Centralized Access Security Lab
# OpenSSH client for the isolated lab network; supports both R1 and SW1.
# Usage: ./scripts/conectar_r1_ssh.sh <IP_DESTINO> <USUARIO>
# Defaults: R1 (10.21.75.1) and netadmin10.
# Legacy algorithms are enabled only for this invocation, not globally.

set -eu

TARGET_IP="${1:-10.21.75.1}"
USERNAME="${2:-netadmin10}"

case "$TARGET_IP" in
  10.21.75.1|10.21.75.2) ;;
  *)
    printf 'Error: IP fuera del inventario del laboratorio: %s\n' "$TARGET_IP" >&2
    printf 'IPs previstas: 10.21.75.1 (R1) y 10.21.75.2 (SW1).\n' >&2
    exit 2
    ;;
esac

if ! command -v ssh >/dev/null 2>&1; then
  echo 'Error: el cliente SSH no está instalado.' >&2
  echo 'Ubuntu/Debian: sudo apt update && sudo apt install -y openssh-client' >&2
  echo 'Alpine: apk add openssh-client' >&2
  exit 127
fi

exec ssh \
  -o KexAlgorithms=+diffie-hellman-group14-sha1 \
  -o HostKeyAlgorithms=+ssh-rsa \
  -o Ciphers=+aes128-cbc \
  "${USERNAME}@${TARGET_IP}"
