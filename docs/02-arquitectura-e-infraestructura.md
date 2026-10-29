# 02. Arquitectura e infraestructura

## Vista de los componentes

![Topología lógica](../images/01-topologia-general.png)

*Figura 1. Diagrama conceptual con las conexiones conocidas. La captura real de GNS3 se insertará en `images/05-gns3-topologia-real.png` y se mostrará aquí automáticamente porque el enlace ya está preparado.*

La topología opera en el mismo segmento IPv4 `10.21.75.0/24`. R1 tiene `10.21.75.1/24` en `GigabitEthernet1/0`; SW1 tiene `10.21.75.2/24` en `Vlan1`; JUMP-SRV tiene `10.21.75.10/24`; el cliente SSH Linux tiene `10.21.75.110` según el inventario compartido.

## Inventario

| Componente | Función | Parámetros confirmados |
|---|---|---|
| R1 | Router/gateway de la red de laboratorio | Cisco C7200, IOS 15.2(4)S6, `Gi1/0 10.21.75.1/24` |
| SW1 | Conmutación y administración por SVI | Cisco IOSvL2, `Vlan1 10.21.75.2/24`, gateway `10.21.75.1` |
| JUMP-SRV | Identidades, DNS y política RADIUS | Windows Server 2019, `10.21.75.10/24`, dominio `jumpserver.lab` |
| Cliente Linux | Cliente SSH de las pruebas | `10.21.75.110`, script `conectar_r1_ssh.sh` |

## Flujo de autenticación

![Arquitectura conceptual AD DS/NPS](../images/02-infraestructura-laboratorio.png)

1. Un operador inicia SSH hacia la IP de R1 o SW1.
2. El dispositivo aplica la lista AAA VTY `VTY-LOGIN`, que consulta el grupo `NPS-GROUP` y dispone de fallback local.
3. El servidor NPS identifica al cliente por la IP de origen RADIUS y evalúa las políticas de red.
4. La política seleccionada valida el grupo de AD y devuelve el atributo Cisco AVPair `shell:priv-lvl=n`.
5. La sesión EXEC usa el nivel devuelto. `show privilege` es la comprobación directa del nivel dentro de la sesión.
6. El accounting EXEC se reporta a NPS usando UDP/1813.

## Conexiones y puertos

- R1 ↔ NPS: UDP 1812 (autenticación) y UDP 1813 (accounting); origen de RADIUS de R1: `GigabitEthernet1/0`.
- SW1 ↔ NPS: UDP 1812 y UDP 1813; origen de RADIUS de SW1: `Vlan1`.
- Administrador Linux → R1/SW1: SSH/TCP 22.
- R1 ↔ SW1: vecino CDP confirmado en los puertos R1 `Gi1/0` y SW1 `Gi0/0`.
- SW1 ↔ JUMP-SRV: conexión del servidor a SW1 reportada por el inventario y la captura de GNS3; `Gi0/1` se documentó como puerto de servidor.

## Captura real de GNS3

![Espacio reservado para la captura real de GNS3](../images/05-gns3-topologia-real.png)

*Figura 2. Este PNG es, por ahora, un marcador explícito; sustituirlo por una captura real de la topología antes de publicar.*

El procedimiento exacto se describe en [Plan de capturas](../images/PLAN-DE-CAPTURAS.md).
