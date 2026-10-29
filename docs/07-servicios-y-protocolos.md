# 07. Servicios y protocolos

![Arquitectura conceptual de los servicios](../images/02-infraestructura-laboratorio.png)

*Figura 1. Diagrama conceptual de los componentes Windows implicados.*

## AAA

AAA separa tres funciones administrativas:

- **Authentication:** verifica la identidad de quien abre SSH.
- **Authorization:** asigna el nivel de EXEC a la sesión después de autenticar.
- **Accounting:** registra el inicio/fin de la sesión u otros eventos de contabilidad configurados.

Las listas finales conocidas utilizan `CONSOLE-LOCAL` para consola, `VTY-LOGIN` para la entrada VTY, `VTY-EXEC` para autorización EXEC y `AUX-LOCAL` para AUX. La lista VTY intenta el grupo RADIUS `NPS-GROUP` y tiene método local de respaldo.

## RADIUS / NPS

NPS escucha en `10.21.75.10` usando UDP/1812 para autenticación y UDP/1813 para accounting. El nombre del servicio de Windows es `IAS`; se observó Running/Automatic y se identificaron endpoints UDP después de corregir una asociación antigua a la IP `10.21.75.138`.

Los clientes RADIUS son R1 (`10.21.75.1`) y SW1 (`10.21.75.2`) y tienen secretos compartidos independientes. Nunca deben aparecer en capturas públicas ni en el repositorio.

![Captura histórica del flujo RADIUS](../images/06-wireshark-radius-diagnostico.png)

*Figura 2. Wireshark permitió observar Access-Request desde R1 al servidor. En esta captura histórica también se ven mensajes ICMP Host Unreachable, por lo que documenta la fase de diagnóstico, no una prueba funcional final.*

## Active Directory

El dominio `jumpserver.lab` centraliza los grupos:

| Grupo | Usuario de prueba | Atributo esperado |
|---|---|---|
| `GG_NET_LEVEL0` | `netadmin0` | `shell:priv-lvl=0` |
| `GG_NET_LEVEL5` | `netadmin5` | `shell:priv-lvl=5` |
| `GG_NET_LEVEL10` | `netadmin10` | `shell:priv-lvl=10` |

![Atributo Cisco AVPair en NPS](../images/13-nps-sw1-l5-atributo-privilegio.png)

*Evidencia real del atributo que determina el nivel EXEC de SW1.*


## SSH

El acceso remoto usa OpenSSH desde un contenedor Linux. El script de este repositorio añade algoritmos heredados a nivel de conexión para compatibilidad con la imagen IOS de laboratorio. No modifica `sshd_config` ni la configuración global del cliente. No se debe copiar esta excepción a redes reales sin una evaluación de seguridad.

## Auditoría

- Evento **6272**: NPS concedió acceso.
- Evento **6273**: NPS rechazó acceso.
- Evento **6274**: NPS descartó una solicitud (útil en diagnósticos específicos).

![Vista de las políticas de red NPS](../images/08-nps-politicas-red.png)

*Figura 3. Lista de políticas. Para demostrar una autorización efectiva, debe correlacionarse con el evento individual y la sesión SSH.*

## Consideraciones de seguridad

PAP no es una elección para redes de producción; se usa aquí como parte del escenario de laboratorio. Mantén el entorno aislado, no publiques contraseñas ni secretos RADIUS y no modifiques las políticas existentes de RD Gateway como método de diagnóstico.
