# 01. Propósito y alcance

## Propósito

Construir y validar un mecanismo de control de acceso administrativo centralizado para R1 y SW1, usando Active Directory como repositorio de identidades y Windows NPS como servidor RADIUS. Las sesiones de administración se establecen por SSH y NPS devuelve un nivel EXEC Cisco (0, 5 o 10) según el grupo de AD.

![Flujo lógico del laboratorio](../images/03-flujo-aaa-radius.png)

*Figura 1. Flujo conceptual de SSH, AAA y RADIUS. Es un diagrama explicativo, no una captura de consola.*

## Objetivos específicos

- Centralizar las identidades de administración en el dominio `jumpserver.lab`.
- Usar clientes RADIUS independientes para R1 (`10.21.75.1`) y SW1 (`10.21.75.2`).
- Asociar grupos `GG_NET_LEVEL0`, `GG_NET_LEVEL5` y `GG_NET_LEVEL10` con `shell:priv-lvl=0`, `5` y `10`.
- Usar SSH para la administración remota y conservar fallback local en VTY.
- Registrar y diagnosticar respuestas NPS mediante eventos 6272 (concesión) y 6273 (rechazo).
- Mantener intactas las políticas preexistentes de RD Gateway y evitar cambios que puedan afectar el rol Windows compartido.

## Alcance incluido

R1, SW1, el servidor JUMP-SRV, el segmento `10.21.75.0/24`, el servicio IAS/NPS, políticas y grupos de AD, SSH, autorización EXEC, contabilidad EXEC y las comprobaciones de conectividad y auditoría documentadas.

## Fuera de alcance

No se ha validado IPsec, alta disponibilidad NPS, MFA ni una migración de PAP a un método moderno. Tampoco se afirma que el laboratorio sea una arquitectura de producción endurecida.

## Estado y criterios de éxito

Se conoce una prueba exitosa de `netadmin5` en SW1: NPS seleccionó `CISCO-SW1-L5`, el usuario entró por SSH y `show privilege` reportó nivel 5. El objetivo de documentación es exponer hechos comprobados y facilitar que se completen las evidencias de las otras combinaciones sin fabricar resultados.

![Captura real de la lista de políticas NPS](../images/08-nps-politicas-red.png)

*Figura 2. Captura real compartida de la consola NPS. Sirve como referencia de la lista de políticas; no sustituye las pruebas de acceso.*

Véase también [pruebas y validación](05-pruebas-y-validacion.md) y el [plan de capturas](../images/PLAN-DE-CAPTURAS.md).
