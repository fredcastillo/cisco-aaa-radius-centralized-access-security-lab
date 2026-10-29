# Script de conexión SSH

[`conectar_r1_ssh.sh`](conectar_r1_ssh.sh) conecta al router o al switch desde el cliente Linux del laboratorio.

## Uso desde la raíz del repositorio

```bash
chmod +x scripts/conectar_r1_ssh.sh
./scripts/conectar_r1_ssh.sh 10.21.75.1 netadmin0
./scripts/conectar_r1_ssh.sh 10.21.75.1 netadmin5
./scripts/conectar_r1_ssh.sh 10.21.75.1 netadmin10
./scripts/conectar_r1_ssh.sh 10.21.75.2 netadmin0
./scripts/conectar_r1_ssh.sh 10.21.75.2 netadmin5
./scripts/conectar_r1_ssh.sh 10.21.75.2 netadmin10
```

La contraseña se solicita de forma interactiva. No la coloques en la línea de comandos ni en un archivo. El script solo acepta como destino las dos IPs del inventario: R1 `10.21.75.1` y SW1 `10.21.75.2`.

Los algoritmos SSH heredados se agregan en esa invocación debido a la compatibilidad de la imagen IOS usada en el laboratorio. El script no cambia la configuración global de OpenSSH.
