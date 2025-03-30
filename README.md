# keepmywin

A Windows PowerShell script to keep track of your system roles and make server reinstalls easier.

## What It Does

This script provides an interactive menu (similar to the Server Manager) that allows you to select and install Windows Server roles and features. Once the installation is complete, it generates a secondary script (`RolesYServicios.ps1`) with all the necessary commands to reinstall those same roles in the future — perfect for automating server setup after a reinstallation.

## How to Use

### Run the Script Normally
Use this to select and install roles interactively:
``powershell
.\InstaladorRoles.ps1

### Run the updater
To only update the secondary script based on currently installed roles
``powershell
.\InstaladorRoles.ps1 -Actualizar
