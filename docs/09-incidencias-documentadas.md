# 09. Incidencias documentadas

## Incidencia principal: `CISCO-SW1-L5` no se seleccionaba

### Síntoma

`netadmin5` no autenticaba contra SW1. El registro NPS mostraba evento 6273 y, en una fase previa, la política seleccionada era la política general `Conexiones a otros servidores de acceso`, con el mensaje de que el método de autenticación no estaba habilitado en la política seleccionada. También constan rechazos tempranos de Reason Code 16 por credenciales no coincidentes; esos eventos pertenecen a intentos anteriores y no deben confundirse con el resultado posterior a la corrección.

### Causa identificada y corrección

La política específica `CISCO-SW1-L5` no estaba coincidiendo como se esperaba. La condición `NAS IPv4 Address = 10.21.75.2` se quitó de esa política y se conservó la condición del grupo `GG_NET_LEVEL5`. No se deben modificar las condiciones de forma improvisada ni reintroducir la condición retirada en esta política.

![Captura de la lista de políticas NPS](../images/08-nps-politicas-red.png)

*Figura 1. Captura auténtica de la lista de NPS que muestra `CISCO-SW1-L5` en la secuencia. Para la evidencia final de la condición corregida se debe tomar la captura descrita en el plan de capturas.*

![Condición funcional del grupo GG_NET_LEVEL5](../images/12-nps-sw1-l5-condicion-grupo.png)

![Atributo Cisco AVPair shell:priv-lvl=5](../images/13-nps-sw1-l5-atributo-privilegio.png)

*Configuración actual de NPS.*


### Validación posterior reportada

- `test aaa group NPS-GROUP netadmin5 ... legacy` en SW1 devolvió `User was successfully authenticated.`
- SSH a `10.21.75.2` como `netadmin5` funcionó.
- `show privilege` dentro de esa sesión reportó nivel 5.
- NPS generó evento 6272 para `CISCO-SW1-L5`, con método PAP.

### Captura histórica distinta: fallos de alcance RADIUS

![Wireshark muestra RADIUS y Host Unreachable](../images/06-wireshark-radius-diagnostico.png)

*Figura 2. Evidencia histórica previa que enseñaba Access-Request y mensajes ICMP Host Unreachable. No se debe atribuir automáticamente esta anomalía antigua a la incidencia NPS de SW1-L5, ni usarla para negar el acceso exitoso posterior.*

![Evento NPS 6272 de la prueba funcional](../images/20-nps-evento-6272-sw1-l5.png)

*Evento reciente de la autenticación e en el visor de sucesos.*


## Anomalía histórica de la IP de escucha de IAS/NPS

En una fase anterior, IAS escuchaba en `10.21.75.138` aunque la IP actual del servidor era `10.21.75.10`. Después de un reinicio controlado de IAS se observaron los endpoints en `10.21.75.10:1812` y `10.21.75.10:1813`. La documentación indica que se corrigió esa asociación. No reinicies IAS de forma improvisada: `TSGateway` fue identificado como servicio dependiente y puede interrumpirse temporalmente.

## Advertencias que no deben confundirse con fallos funcionales

- La sintaxis histórica `radius-server host ...` generaba una advertencia de obsolescencia, no un rechazo inmediato de configuración.
- `show aaa servers` con estado `UP` no prueba que la autenticación se haya completado; revisa solicitudes, respuestas y eventos correlacionados.
- Los contadores existentes son acumulativos. Una retransmisión antigua no significa que la última prueba también haya fallado.
- Un primer ping de 4/5 puede coincidir con resolución ARP inicial; repetirlo antes de afirmar que existe pérdida persistente.

## Cómo registrar una incidencia nueva

Anota hora local, usuario de prueba, dispositivo, política NPS realmente seleccionada, código de evento, salida de `show aaa servers` antes/después y resultado de `show privilege`. Captura la evidencia original y evita incluir credenciales.
