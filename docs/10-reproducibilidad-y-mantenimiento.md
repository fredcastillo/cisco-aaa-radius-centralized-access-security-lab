# 10. Reproducibilidad y mantenimiento

## Dependencias

- GNS3 con imágenes compatibles de Cisco C7200/IOSvL2.
- Windows Server 2019 con AD DS, DNS y Network Policy Server instalados.
- Dominio `jumpserver.lab`, los grupos de red y los usuarios de prueba existentes.
- Cliente Linux con OpenSSH instalado y conectividad al segmento `10.21.75.0/24`.
- Conectividad de los clientes RADIUS a `10.21.75.10` sobre UDP/1812 y UDP/1813.

![Marcador de captura real de GNS3](../images/05-gns3-topologia-real.png)

*Figura 1. Antes de publicar, reemplaza este marcador por una captura de GNS3 con los cuatro nodos y sus enlaces. El nombre y la ruta se mantienen para que todas las referencias se actualicen automáticamente.*

![Clientes RADIUS definidos en NPS](../images/11-nps-clientes-radius.png)

*Captura pendiente: lista RADIUS Clients con R1 (`10.21.75.1`) y SW1 (`10.21.75.2`); no mostrar secretos.*


## Pasos de reproducción seguros

1. Arranca el proyecto y confirma la conectividad física/virtual y las IPs.
2. En Windows Server, revisa `Get-Service IAS` y los endpoints UDP/1812 y UDP/1813.
3. En NPS, verifica los clientes `10.21.75.1` y `10.21.75.2` y las políticas Cisco. No modifiques las políticas RD Gateway para depurar AAA.
4. Desde el cliente Linux, abre una sesión SSH nueva al dispositivo de destino con el usuario correspondiente.
5. Dentro de Cisco ejecuta `show privilege`; cierra la sesión y revisa inmediatamente los eventos NPS 6272/6273.
6. Registra el resultado real de cada combinación en `tests/test-matrix.csv`.
7. Si una autenticación falla, conserva la captura original y consulta la política seleccionada antes de editar condiciones.

## Respaldo y persistencia

Antes de cualquier cambio en un router o switch, conserva localmente una copia privada de `show running-config` y `show startup-config`. No compartas las salidas sin redactar `key`, `secret`, hashes de usuarios, comunidades SNMP ni otros datos sensibles. Guarda los cambios con `copy running-config startup-config` solo después de verificar una vía de recuperación local y el acceso remoto.

Los archivos de [`running-configs/`](../running-configs/README.md) contienen extractos de configuración final conocida, no una reconstrucción inventada del volcado íntegro. La salida literal de un equipo actual es la fuente de verdad para completar un archivo de running-config.

![Lista real de políticas NPS](../images/08-nps-politicas-red.png)

*Figura 2. La captura muestra las políticas que deben mantenerse intactas mientras se reproduce el procedimiento de acceso.*

## Seguridad

- Conserva los secretos RADIUS existentes en los equipos y NPS; no los escribas en README, Markdown, scripts ni capturas.
- Las contraseñas de los usuarios de prueba se introducen de forma interactiva, nunca como parte de comandos que queden guardados en el historial del shell.
- El script SSH usa algoritmos de compatibilidad heredada por conexión. No los habilites en configuración global ni copies el patrón a sistemas productivos.
- PAP se documenta por compatibilidad con el escenario del laboratorio, no como recomendación para producción.
- El rol Windows incluye servicios existentes; no reinicies IAS sin revisar el impacto en TSGateway.

## Mantenimiento de evidencias

Cuando se obtenga una nueva captura, guárdala en `images/` con el nombre exacto del plan y actualiza la matriz CSV. Las capturas Wireshark ya incluidas documentan una fase histórica de problemas de conectividad; no las sobrescribas ni las etiquetes como estado actual.
