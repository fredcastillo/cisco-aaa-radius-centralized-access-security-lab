# Pruebas SSH por dispositivo y nivel

## Preparación

Desde la raíz del repositorio en el cliente Linux, ejecuta una vez:

```bash
chmod +x scripts/conectar_r1_ssh.sh
```

El script ya contiene las IPs conocidas. No hay que editarlo para cambiar de router a switch: pasa IP y usuario como argumentos. La contraseña se introduce de forma interactiva en SSH.

## Matriz de sesiones

Abre una sesión nueva por cada comando, ejecuta `show privilege` dentro del CLI Cisco y después `exit`.

```bash
./scripts/conectar_r1_ssh.sh 10.21.75.1 netadmin0
./scripts/conectar_r1_ssh.sh 10.21.75.1 netadmin5
./scripts/conectar_r1_ssh.sh 10.21.75.1 netadmin10
./scripts/conectar_r1_ssh.sh 10.21.75.2 netadmin0
./scripts/conectar_r1_ssh.sh 10.21.75.2 netadmin5
./scripts/conectar_r1_ssh.sh 10.21.75.2 netadmin10
```

| IP de destino | Dispositivo | Usuario | Nivel esperado por política |
|---|---|---|---:|
| `10.21.75.1` | R1 | `netadmin0` | 0 |
| `10.21.75.1` | R1 | `netadmin5` | 5 |
| `10.21.75.1` | R1 | `netadmin10` | 10 |
| `10.21.75.2` | SW1 | `netadmin0` | 0 |
| `10.21.75.2` | SW1 | `netadmin5` | 5 |
| `10.21.75.2` | SW1 | `netadmin10` | 10 |

Los niveles de la tabla son los esperados por diseño, no una garantía de que cada sesión futura pase. Registra el valor realmente emitido por `show privilege` en `tests/test-matrix.csv` y obtén una captura conforme a `images/PLAN-DE-CAPTURAS.md`.

## Correlación con NPS

Después de un acceso SSH, en `JUMP-SRV` busca el evento 6272 o 6273 en **Event Viewer → Windows Logs → Security**. Comprueba usuario, cliente RADIUS y nombre de política. No uses un evento de otra hora como prueba de esta sesión.

## Precaución de compatibilidad

El script habilita `diffie-hellman-group14-sha1`, `ssh-rsa` y `aes128-cbc` solamente en esa invocación, para la imagen IOS de este laboratorio. No habilites esos algoritmos globalmente ni los uses como recomendación de producción.
