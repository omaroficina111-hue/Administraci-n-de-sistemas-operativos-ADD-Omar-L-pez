# ==============================================================================
# SCRIPT DE AUTOMATIZACIÓN DE ACTIVE DIRECTORY EN POWERSHELL
# Autor: Omar
# Dominio: omar.aws
# Descripción: Script interactivo para consultar y administrar objetos en AD.
# ==============================================================================

# Importamos el módulo de PowerShell para Active Directory (necesario para usar comandos como Get-ADUser, New-ADGroup, etc.)
Import-Module ActiveDirectory

# Iniciamos un bucle do-while para que el menú se muestre de forma continua hasta que el usuario decida salir (opción 5)
do {
    # Mostramos por pantalla las opciones disponibles en el menú interactivo
    Write-Host "`n=========================================="
    Write-Host "     MENÚ DE GESTIÓN DE ACTIVE DIRECTORY"
    Write-Host "=========================================="
    Write-Host "1. Mostrar información del dominio"
    Write-Host "2. Crear Unidad Organizativa (OU)"
    Write-Host "3. Crear Grupo"
    Write-Host "4. Crear Usuario"
    Write-Host "5. Salir"
    
    # Solicitamos al usuario que introduzca un número del 1 al 5
    $opcion = Read-Host "Elige una opción (1-5)"

    # Evaluamos la opción elegida mediante la estructura de control 'switch'
    switch ($opcion) {
        
        # ----------------------------------------------------------------------
        # OPCIÓN 1: MOSTRAR INFORMACIÓN DEL DOMINIO
        # ----------------------------------------------------------------------
        "1" {
            Write-Host "`n--- INFORMACIÓN DEL DOMINIO ---"
            
            # $env:COMPUTERNAME obtiene la variable de entorno con el nombre local del servidor
            Write-Host "Nombre del Equipo: $env:COMPUTERNAME"
            
            # (Get-ADDomain).Name consulta en Active Directory el nombre del dominio actual
            Write-Host "Nombre del Dominio: $((Get-ADDomain).Name)"
            
            # Contamos cuántas Unidades Organizativas existen buscando todas con -Filter * y contando los resultados (.Count)
            Write-Host "Total de OUs: $((Get-ADOrganizationalUnit -Filter *).Count)"
            
            # Contamos el total de grupos existentes en Active Directory
            Write-Host "Total de Grupos: $((Get-ADGroup -Filter *).Count)"
            
            # Contamos el total de cuentas de usuario registradas en Active Directory
            Write-Host "Total de Usuarios: $((Get-ADUser -Filter *).Count)"
        }

        # ----------------------------------------------------------------------
        # OPCIÓN 2: CREAR UNA NUEVA UNIDAD ORGANIZATIVA (OU)
        # ----------------------------------------------------------------------
        "2" {
            Write-Host "`n--- CREAR UNIDAD ORGANIZATIVA ---"
            
            # Pedimos al usuario que escriba el nombre de la nueva OU
            $ou = Read-Host "Introduce el nombre de la nueva OU"
            
            # New-ADOrganizationalUnit crea la OU en la raíz del dominio actual ((Get-ADDomain).DistinguishedName)
            New-ADOrganizationalUnit -Name $ou -Path (Get-ADDomain).DistinguishedName
            
            # Confirmamos al usuario que la operación se ha realizado con éxito
            Write-Host "¡Éxito! La Unidad Organizativa '$ou' ha sido creada correctamente."
        }

        # ----------------------------------------------------------------------
        # OPCIÓN 3: CREAR UN NUEVO GRUPO DE SEGURIDAD
        # ----------------------------------------------------------------------
        "3" {
            Write-Host "`n--- CREAR NUEVO GRUPO ---"
            
            # Solicitamos el nombre para el nuevo grupo
            $grupo = Read-Host "Introduce el nombre del nuevo grupo"
            
            # New-ADGroup crea un grupo global de seguridad en Active Directory
            New-ADGroup -Name $grupo -GroupScope Global -GroupCategory Security
            
            # Confirmación de creación
            Write-Host "¡Éxito! El grupo '$grupo' ha sido creado correctamente."
        }

        # ----------------------------------------------------------------------
        # OPCIÓN 4: CREAR UN NUEVO USUARIO Y ASIGNARLO A UN GRUPO
        # ----------------------------------------------------------------------
        "4" {
            Write-Host "`n--- CREAR NUEVO USUARIO ---"
            
            # Recopilamos los datos personales y de cuenta solicitados al usuario
            $nombre = Read-Host "Nombre del usuario"
            $apellido = Read-Host "Apellidos del usuario"
            $usuario = Read-Host "Nombre de usuario para iniciar sesión (sAMAccountName)"
            $grupoDestino = Read-Host "Nombre del grupo al que deseas asignarlo"
            
            # -AsSecureString oculta los caracteres de la contraseña en la pantalla por seguridad
            $pass = Read-Host "Introduce la contraseña temporal" -AsSecureString
            
            # New-ADUser crea la cuenta en Active Directory con los parámetros especificados:
            # - Enabled $true: activa la cuenta inmediatamente.
            # - ChangePasswordAtLogon $true: OBLIGA al usuario a cambiar la clave en su primer inicio de sesión.
            New-ADUser -Name "$nombre$apellido" `
                       -GivenName $nombre `
                       -Surname $apellido `
                       -SamAccountName $usuario `
                       -AccountPassword $pass `
                       -Enabled $true `
                       -ChangePasswordAtLogon $true
                       
            # Add-ADGroupMember vincula/añade el nuevo usuario recién creado al grupo indicado
            Add-ADGroupMember -Identity $grupoDestino -Members $usuario
            
            # Confirmación final del proceso
            Write-Host "¡Éxito! Usuario '$usuario' creado, configurado con cambio de clave y añadido al grupo '$grupoDestino'."
        }

        # ----------------------------------------------------------------------
        # OPCIÓN 5: SALIR DEL PROGRAMA
        # ----------------------------------------------------------------------
        "5" {
            Write-Host "`nSaliendo de la aplicación de gestión... ¡Hasta pronto!"
        }

        # Opción por defecto en caso de introducir un número o carácter distinto a 1-5
        default {
            Write-Host "`n[ERROR] Opción no válida. Por favor, elige un número del 1 al 5."
        }
    }

# El bucle se repite continuamente hasta que $opcion sea igual a "5"
} while ($opcion -ne "5")