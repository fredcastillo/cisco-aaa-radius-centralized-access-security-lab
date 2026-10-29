# 05. Pruebas y validación

## Evidencia confirmada en el historial

La prueba funcional más explícita del registro de trabajo fue `netadmin5` contra SW1:

1. `test aaa group NPS-GROUP netadmin5 ... legacy` respondió `User was successfully authenticated.` (la contraseña se introdujo localmente y no se publica).
2. El usuario entró por SSH a `10.21.75.2`.
3. `show privilege` reportó `Current privilege level is 5`.
4. NPS registró evento 6272 y la política `CISCO-SW1-L5`, con método PAP.
5. La causa previa fue que NPS no seleccionaba la política de nivel 5 en SW1; se retiró la condición de NAS IP en esa política y se conservó el grupo `GG_NET_LEVEL5`.

![Lista NPS que incluye CISCO-SW1-L5](../images/08-nps-politicas-red.png)

*Figura 1. Evidencia de la presencia de `CISCO-SW1-L5` en la consola NPS. El detalle de la condición y del atributo debe registrarse en las capturas adicionales descritas en el plan.*

## Evidencia histórica de troubleshooting

![Wireshark mostrando Access-Request y Destination Unreachable](../images/06-wireshark-radius-diagnostico.png)

*Figura 2. Captura histórica: se ven Access-Request RADIUS desde `10.21.75.1` hacia `10.21.75.10`, junto con mensajes ICMP “Destination unreachable (Host unreachable)”. La captura pertenece a una fase anterior del diagnóstico; no se debe usar como prueba de que la sesión final falla.*

![Wireshark con solicitudes repetidas](../images/07-wireshark-radius-retransmisiones.png)

*Figura 3. Captura histórica de retransmisiones/doble solicitud en el flujo de diagnóstico RADIUS.*

## Matriz funcional a completar

La configuración espera los niveles 0, 5 y 10 para los tres usuarios. El historial confirma al menos la prueba de `netadmin5` en ambos dispositivos y las pruebas de `netadmin0` y `netadmin10` que se reportaron funcionales en R1/SW1. Aun así, el paquete no sustituye una repetición final y fechada de las seis combinaciones, por eso la matriz CSV separa lo reportado de las pruebas nuevas que haga el evaluador.

| Dispositivo | Usuario | Nivel esperado | Evidencia concreta registrada |
|---|---|---:|---|
| R1 `10.21.75.1` | `netadmin0` | 0 | Reportado funcional en el historial; nueva captura pendiente. |
| R1 `10.21.75.1` | `netadmin5` | 5 | Reportado funcional; nueva captura pendiente. |
| R1 `10.21.75.1` | `netadmin10` | 10 | Reportado funcional; nueva captura pendiente. |
| SW1 `10.21.75.2` | `netadmin0` | 0 | Reportado funcional; nueva captura pendiente. |
| SW1 `10.21.75.2` | `netadmin5` | 5 | Acceso SSH y privilegio 5 confirmados; evento 6272 confirmado. |
| SW1 `10.21.75.2` | `netadmin10` | 10 | Reportado funcional; nueva captura pendiente. |

## Procedimiento para cada sesión SSH

Desde el cliente Linux en la subred del laboratorio, ejecuta uno de los comandos siguientes y suministra la contraseña cuando SSH la solicite:

```bash
./scripts/conectar_r1_ssh.sh 10.21.75.1 netadmin0
./scripts/conectar_r1_ssh.sh 10.21.75.1 netadmin5
./scripts/conectar_r1_ssh.sh 10.21.75.1 netadmin10
./scripts/conectar_r1_ssh.sh 10.21.75.2 netadmin0
./scripts/conectar_r1_ssh.sh 10.21.75.2 netadmin5
./scripts/conectar_r1_ssh.sh 10.21.75.2 netadmin10
```

Dentro de cada sesión Cisco:

```cisco
show privilege
exit
```

Captura el comando y la respuesta completa; no capturas contraseñas. La guía específica está en [Plan de capturas](../images/PLAN-DE-CAPTURAS.md).

## Evidencia visual de las seis sesiones SSH

Las imágenes siguientes son marcadores etiquetados. Cuando captures cada sesión nueva y sobrescribas el PNG con el mismo nombre, el documento mostrará el resultado real.

![R1 netadmin0 nivel 0](../images/14-ssh-r1-netadmin0-privilege0.png)

![R1 netadmin5 nivel 5](../images/15-ssh-r1-netadmin5-privilege5.png)

![R1 netadmin10 nivel 10](../images/16-ssh-r1-netadmin10-privilege10.png)

![SW1 netadmin0 nivel 0](../images/17-ssh-sw1-netadmin0-privilege0.png)

![SW1 netadmin5 nivel 5](../images/18-ssh-sw1-netadmin5-privilege5.png)

![SW1 netadmin10 nivel 10](../images/19-ssh-sw1-netadmin10-privilege10.png)



## Validación NPS correlacionada

En `JUMP-SRV` abre Event Viewer → Windows Logs → Security y busca eventos 6272/6273 por hora de la prueba. El evento debe identificar el usuario, el cliente RADIUS y la política realmente aplicada. La evidencia más útil incluye el evento 6272 de `netadmin5` / `CISCO-SW1-L5`; captura uno nuevo tras repetir la prueba y evita reutilizar un evento antiguo como si fuera actual.

![Evento NPS 6272 para SW1 nivel 5](../images/20-nps-evento-6272-sw1-l5.png)

*Figura 4. Sustituir con el evento real correlacionado a una sesión reciente de `netadmin5` en SW1.*


## Contadores AAA/RADIUS

`show aaa servers` informa estado y contadores acumulados. Una salida `UP` no garantiza que una autenticación haya concluido. Para una comprobación limpia:

1. Cierra las sesiones previas y elige una única prueba.
2. En ambos equipos, captura contadores actuales antes de limpiarlos.
3. Ejecuta `clear radius statistics` solo al comienzo de una ventana de prueba controlada.
4. Abre una sesión SSH nueva, ejecuta `show privilege` y sal.
5. Ejecuta `show aaa servers` y correlaciona con los eventos de NPS.

No se declara un resultado nuevo hasta observarlo.
