# 04. Configuración paso a paso

Este runbook describe la configuración lógica conocida. Está orientado a reproducir y comprobar el laboratorio existente sin rehacerlo ni sobrescribir secretos. No pegues comandos de configuración sin contrastarlos con el estado actual del equipo.

## 1. Preparación del entorno

1. Inicia el proyecto en GNS3 y verifica que R1, SW1, JUMP-SRV y el cliente Linux están encendidos y conectados.
2. Confirma IPs con `show ip interface brief` en Cisco y `Get-NetIPAddress -AddressFamily IPv4` en Windows.
3. Verifica que `JUMP-SRV` mantiene el dominio `jumpserver.lab` y los servicios AD DS, DNS y NPS.

![Topología real de GNS3: marcador hasta reemplazar](../images/05-gns3-topologia-real.png)

*Figura 1. Sustituye la imagen por la captura de GNS3 con todos los nodos y enlaces visibles; no es necesario volver a crear el diagrama conceptual.*

## 2. Active Directory

Se usan estos grupos globales de seguridad y usuarios de prueba:

| Grupo | Usuario de prueba asociado |
|---|---|
| `GG_NET_LEVEL0` | `netadmin0` |
| `GG_NET_LEVEL5` | `netadmin5` |
| `GG_NET_LEVEL10` | `netadmin10` |

No recrees los usuarios o grupos si ya existen. Antes de una prueba fallida revisa la pertenencia efectiva en Active Directory Users and Computers (ADUC) o con PowerShell de solo lectura.

## 3. Clientes RADIUS en NPS

En `JUMP-SRV`, abre Server Manager → Tools → **Network Policy Server** → **RADIUS Clients and Servers** → **RADIUS Clients**. Deben constar:

- R1: `10.21.75.1`, fabricante Cisco.
- SW1: `10.21.75.2`, fabricante Cisco.

Los secretos se han configurado por separado y no se documentan. No captures ni exportes el campo secreto en una imagen pública.

![Lista real de clientes RADIUS](../images/11-nps-clientes-radius.png)

*Figura 2. Espacio de evidencia para los clientes RADIUS R1 y SW1; reemplaza el marcador después de capturar la lista en NPS.*


## 4. Políticas de red NPS

Las seis políticas conocidas son `CISCO-R1-L0/L5/L10` y `CISCO-SW1-L0/L5/L10`. Cada una corresponde al grupo de AD adecuado y debe devolver el atributo Cisco AVPair apropiado. El método de autenticación PAP se usó en este laboratorio académico aislado.

![Lista real de políticas NPS](../images/08-nps-politicas-red.png)

*Figura 3. Captura real de NPS aportada para documentar la lista y el orden visible. Para demostrar el parámetro de una política concreta, sigue las evidencias 12 y 13 del plan de capturas.*

### Corrección importante para `CISCO-SW1-L5`

La condición `NAS IPv4 Address = 10.21.75.2` se retiró de `CISCO-SW1-L5`, manteniendo `GG_NET_LEVEL5`. No la vuelvas a añadir: esa modificación permitió que NPS seleccionara la política para `netadmin5` en SW1.

![Condición de grupo de CISCO-SW1-L5](../images/12-nps-sw1-l5-condicion-grupo.png)

*Figura 4. Debe mostrar GG_NET_LEVEL5 y no una condición de NAS IPv4 reintroducida.*

![Atributo Cisco AVPair de nivel 5](../images/13-nps-sw1-l5-atributo-privilegio.png)

*Figura 5. Debe mostrar `shell:priv-lvl=5` en las propiedades de la política.*


## 5. AAA / SSH en Cisco

Las listas finales conocidas se encuentran en [`running-configs/`](../running-configs/README.md). Los bloques incluyen `NPS-GROUP`, `CONSOLE-LOCAL`, `VTY-LOGIN`, `VTY-EXEC` y `AUX-LOCAL`; no reconstruyen las líneas de secretos porque deben conservarse las credenciales locales existentes.

La lista VTY aplica autenticación `group NPS-GROUP local`, autorización EXEC `group NPS-GROUP local` y permite solo SSH en el transporte VTY. La consola y AUX mantienen listas locales dedicadas. En SW1 la interfaz origen de RADIUS es `Vlan1`; en R1 es `GigabitEthernet1/0`.

## 6. Validación mínima tras configurar

Ejecuta en cada dispositivo:

```cisco
show ip interface brief
show aaa servers
show radius statistics
show privilege
```

`show privilege` debe ejecutarse **dentro de cada sesión SSH**. Para los seis cruces, usa [pruebas-ssh.md](../commands/pruebas-ssh.md) y anota únicamente los resultados obtenidos. No uses contadores acumulados como prueba limpia; si vas a limpiar contadores, hazlo al principio de una prueba controlada.

![Evidencia histórica del diagnóstico RADIUS](../images/06-wireshark-radius-diagnostico.png)

*Figura 6. Captura real antigua de Access-Request y mensajes ICMP Host Unreachable. Se conserva como parte de la historia del troubleshooting, no como resultado final después de la corrección.*
