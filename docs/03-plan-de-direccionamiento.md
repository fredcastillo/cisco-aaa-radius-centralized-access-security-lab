# 03. Plan de direccionamiento

## Segmento IPv4

![Topología con direcciones conocidas](../images/01-topologia-general.png)

*Figura 1. Diagrama conceptual.*

| Dispositivo | Interfaz | IPv4 | Máscara | Gateway / notas |
|---|---|---:|---|---|
| R1 | `GigabitEthernet1/0` | `10.21.75.1` | `255.255.255.0` (`/24`) | Interfaz conectada al segmento; gateway usado por SW1/servidor. |
| SW1 | `Vlan1` | `10.21.75.2` | `255.255.255.0` (`/24`) | `ip default-gateway 10.21.75.1`. |
| JUMP-SRV | Adaptador Ethernet | `10.21.75.10` | `255.255.255.0` (`/24`) | Gateway `10.21.75.1`; dominio `jumpserver.lab`. |
| Cliente Linux | Interfaz del contenedor | `10.21.75.110` | Inventario: misma subred `/24` | Se usa para SSH hacia R1/SW1. |

Red: `10.21.75.0/24`. Broadcast: `10.21.75.255`. Hosts utilizables: `10.21.75.1` a `10.21.75.254`.

![Captura real de conectividad de R1](../images/09-r1-conectividad.png)

*Figura 2.*

![Captura real de conectividad de SW1](../images/10-sw1-conectividad.png)

*Figura 3.*


## Puertos y protocolos relevantes

| Servicio | Puerto | Transporte | Uso |
|---|---:|---|---|
| SSH | 22 | TCP | Administración remota a R1 y SW1. |
| RADIUS Authentication | 1812 | UDP | Solicitudes y respuestas de autenticación. |
| RADIUS Accounting | 1813 | UDP | Inicio/fin de sesiones y contabilidad EXEC. |
| Syslog/Windows Event Log | Depende del mecanismo | Local | Eventos y auditoría de NPS; no se presupone un puerto remoto de logging. |

## Verificación en los dispositivos

En R1 y SW1 abre la consola del dispositivo en GNS3 y ejecuta:

```cisco
show ip interface brief
show ip route
show cdp neighbors
```

En SW1 añade `show vlan brief`. La evidencia de interfaces que debes capturar se define en [plan de capturas 09 y 10](../images/PLAN-DE-CAPTURAS.md#09-09-r1-conectividadpng).

![Evidencia histórica de tráfico RADIUS](../images/07-wireshark-radius-retransmisiones.png)

*Figura 4. Captura histórica de Wireshark que confirma solicitudes UDP con origen `10.21.75.1` y destino `10.21.75.10`, puerto de destino 1812. Es evidencia diagnóstica antigua, no una certificación del estado actual.*
