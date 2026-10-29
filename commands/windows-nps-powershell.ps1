# Cisco AAA & RADIUS Centralized Access Security Lab
# Ejecutar en JUMP-SRV con PowerShell elevado cuando proceda.
# Consulta solo estado; no reinicia servicios ni modifica políticas.

Write-Host "=== Servicio NPS / IAS ==="
Get-Service IAS | Select-Object Name, DisplayName, Status, StartType | Format-Table -AutoSize

Write-Host "`n=== Servicios dependientes de IAS (solo consulta) ==="
Get-Service -Name IAS -DependentServices -ErrorAction SilentlyContinue |
    Select-Object Name, DisplayName, Status, StartType | Format-Table -AutoSize

Write-Host "`n=== Endpoints UDP RADIUS 1812 y 1813 ==="
Get-NetUDPEndpoint -LocalPort 1812,1813 -ErrorAction SilentlyContinue |
    Select-Object LocalAddress, LocalPort, OwningProcess | Format-Table -AutoSize

Write-Host "`n=== IPv4 configuradas en el servidor ==="
Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Select-Object InterfaceAlias, IPAddress, PrefixLength, AddressState |
    Format-Table -AutoSize

Write-Host "`n=== Últimos eventos NPS (últimas 2 horas) ==="
$desde = (Get-Date).AddHours(-2)
Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id = 6272,6273,6274
    StartTime = $desde
} -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match '10\.21\.75\.1|10\.21\.75\.2|netadmin0|netadmin5|netadmin10' } |
    Select-Object TimeCreated, Id, ProviderName, Message |
    Format-List

Write-Host "`n=== Auditoría NPS ==="
auditpol /get /subcategory:"Servidor de directivas de redes"

# Para correlación precisa, anota una hora ANTES de realizar una única prueba:
# $inicio = Get-Date
# Ejecuta una sesión SSH o un test AAA desde Cisco y, después, consulta:
# Get-WinEvent -FilterHashtable @{ LogName='Security'; Id=6272,6273,6274; StartTime=$inicio } |
#   Select-Object TimeCreated,Id,Message | Format-List
# No captures ni compartas contraseñas o secretos RADIUS.
