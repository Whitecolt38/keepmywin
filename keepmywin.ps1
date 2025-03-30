param(
    [switch]$Actualizar
)

# Ruta del script secundario
$scriptSecundario = Join-Path -Path $PSScriptRoot -ChildPath "RolesYServicios.ps1"

function Generar-ScriptSecundario {
    $rolesInstalados = Get-WindowsFeature | Where-Object {$_.Installed -eq $true -and $_.InstallState -eq "Installed"}
    $lineas = @(
        "# Script generado automaticamente para reinstalar roles y caracteristicas",
        "# Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
        "",
        "foreach (\$rol in @("
    )

    foreach ($rol in $rolesInstalados) {
        $lineas += '    "' + $rol.Name + '",'  
    }

    if ($lineas.Count -gt 4) {
        $lineas[-1] = $lineas[-1].TrimEnd(',')  # Eliminar coma final si hay roles
    }

    $lineas += @(
        ")) {",
        "    Install-WindowsFeature -Name \$rol -IncludeManagementTools -ErrorAction SilentlyContinue",
        "}"
    )

    Set-Content -Path $scriptSecundario -Value $lineas -Encoding UTF8
    Write-Host "Script 'RolesYServicios.ps1' generado en: $scriptSecundario" -ForegroundColor Green
}

if ($Actualizar) {
    Write-Host "Actualizando script con roles actuales instalados..." -ForegroundColor Cyan
    Generar-ScriptSecundario
    exit
}

# Verificar si Out-GridView está disponible
if (-not (Get-Command Out-GridView -ErrorAction SilentlyContinue)) {
    Write-Error "Out-GridView no está disponible. Por favor, instala el componente de interfaz gráfica o usa una versión con GUI."
    exit
}

# Mostrar selector de roles
$rolesDisponibles = Get-WindowsFeature | Where-Object {$_.InstallState -eq "Available" -or $_.InstallState -eq "Removed"}
$seleccion = $rolesDisponibles | Out-GridView -PassThru -Title "Selecciona los roles y características a instalar"

if ($seleccion) {
    foreach ($rol in $seleccion) {
        Write-Host "Instalando: $($rol.Name)..." -ForegroundColor Yellow
        Install-WindowsFeature -Name $rol.Name -IncludeManagementTools
    }
    Generar-ScriptSecundario
} else {
    Write-Host "No se seleccionaron roles."
}