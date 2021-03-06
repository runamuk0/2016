## view the Win32_Service class
$class = Get-CimClass -ClassName Win32_service
$class
$class.CimClassMethods
$class.CimClassProperties

## view output from Win32_Service
Get-CimInstance -ClassName Win32_Service

## first pass module - basic get
Get-Module CIMservice | Remove-Module
Import-Module 'C:\CIMdemo\CIMService\v1\CIMservice.cdxml' -Force
## notice CIM module
Get-Module 
Get-Command -Module CIMservice
Get-Command Get-CIMService -Syntax
Get-CIMService

## start adding parameters
$class.CimClassProperties | Where-Object Name -like '*Name*'
## using Name property
Get-Module CIMservice | Remove-Module
Import-Module 'C:\CIMdemo\CIMService\v2\CIMservice.cdxml' -Force
Get-Command -Module CIMservice
Get-Command Get-CIMService -Syntax
Get-CIMService
Get-CIMService -Name bits
Get-CIMService -Name bi*

## add more parameters
Get-Module CIMservice | Remove-Module
Import-Module 'C:\CIMdemo\CIMService\v3\CIMservice.cdxml' -Force
Get-Command Get-CIMService -Syntax
Get-CIMService
## service state
Get-CIMService -State Running
Get-CIMService -State 'Running', 'Stopped'
Get-CIMService -State 'Running', 'Stopped'
Get-CIMService -State Stopped
## this should error
Get-CIMService -State Stoppes
## tab completion deals with spaces
Get-CIMService -State 'Start Pending'
Get-CIMService -State Paused
## service names
Get-CIMService -Name bits
Get-CIMService -Name bi*
Get-CIMService -Name bi* | Select-Object Name, Displayname
Get-CIMService -DisplayName *transfer*
## start mode
Get-CIMService -StartMode Auto
## combine parameters
Get-CIMService -StartMode Auto -State Stopped
Get-CIMService -StartMode Manual -State Running
## boolean values
## service started
Get-CIMService -Started $true
Get-CIMService -Started $false
## other booleans
Get-CIMService -DelayedAutoStart $true
Get-CIMService -AcceptPause $true
Get-CIMService -AcceptStop $true
Get-CIMService -DesktopInteract $true
## service type
Get-CimInstance -ClassName Win32_Service | Sort-Object ServiceType | Select-Object Name, ServiceType
Get-CIMService -ServiceType 'Share Process'
## status
Get-CIMService -Status Error
Get-CIMService -Status OK
Get-CIMService -Status OK -State Stopped
Get-CIMService -Status OK -State Stopped -StartMode Auto

## add some parameter sets
##   these are arbitrary
Get-Module CIMservice | Remove-Module
Import-Module 'C:\CIMdemo\CIMService\v4\CIMservice.cdxml' -Force
Get-Command Get-CIMService -Syntax
Get-CIMService -State Running -StartMode Auto
Get-CIMService -Name b*
Get-CIMService -Name b* -DelayedAutoStart $true
Get-CIMService -Name b* -DelayedAutoStart $true -Started $true
## usual error if cross parameter sets
Get-CIMService -Name b* -State Running

## 
## Now add some methods
Get-Module CIMservice | Remove-Module
Import-Module 'C:\CIMdemo\CIMService\v5\CIMservice.cdxml' -force
Get-Command -Module CIMservice
Get-Command Get-CIMService -Syntax
Get-Command Start-CIMService -Syntax
Get-Command Stop-CIMService -Syntax

## make sure BITS service is stopped
Stop-CIMService -Name bits

## working by name
Get-CIMService -Name bits
Start-CIMService -Name bits
Get-CIMService -Name bits
Stop-CIMService -Name bits
Get-CIMService -Name bits

## pipeline
Get-CIMService -Name bits | Start-CIMService
Get-CIMService -Name bits
Get-CIMService -Name bits | Stop-CIMService
Get-CIMService -Name bits

## can combine with Get-CimInstance
Get-CimInstance -ClassName Win32_Service -Filter "Name='BITS'"
Get-CimInstance -ClassName Win32_Service -Filter "Name='BITS'" | Start-CIMService
Get-CIMService -Name bits
Get-CimInstance -ClassName Win32_Service -Filter "Name='BITS'" | Stop-CIMService
Get-CIMService -Name bits

##
## setting start mode
$class.CimClassMethods['ChangeStartMode'].Parameters
Get-Module CIMservice | Remove-Module
Import-Module 'C:\CIMdemo\CIMService\v6\CIMservice.cdxml' -Force
Get-Command -Module CIMservice
Get-Command Set-CIMServiceStartMode -Syntax
Get-CIMService -Name bits
Stop-CIMService -Name bits
Set-CIMServiceStartMode -Name bits -StartMode Disabled
Get-CIMService -Name bits
Start-CIMService -Name bits
Get-CIMService -Name bits
##
Set-CIMServiceStartMode -Name bits -StartMode Manual
Get-CIMService -Name bits
Start-CIMService -Name bits
## BITS on Windows 10 is odd
## resets to Auto even if perform action in GUI
Get-CIMService -Name bits

##
##  pausing service
Get-CIMService -AcceptPause $true
Get-CIMService -AcceptPause $true | Select-Object Name, DisplayName
Suspend-CIMService -Name LanmanWorkstation
Get-CIMService -AcceptPause $true
Resume-CIMService -Name LanmanWorkstation
Get-CIMService -AcceptPause $true

##
##  verbose
##  whatif & confirm
Get-Command Stop-CIMService -Syntax
## try verbose
Stop-CIMService -Name bits -Verbose
Start-CIMService -Name bits -Verbose
## try whatif
Get-CIMService -Name bits
Stop-CIMService -Name bits -WhatIf
Get-CIMService -Name bits
Start-CIMService -Name bits

##
## PROVIDER doen't support whatif 
## so need to hndle on client side
## remember the Confirm Impact is set to High
##  in the CDXML
Get-Module CIMservice | Remove-Module
Import-Module 'C:\CIMdemo\CIMService\v7\CIMservice.cdxml' -Force
Stop-CIMService -Name bits -Verbose
Get-CIMService -Name bits
Start-CIMService -Name bits -Confirm:$false
Get-CIMService -Name bits
Stop-CIMService -Name bits -WhatIf
##
##  verbose is present but
##  doesn't do anything in CDXML
## try a MS cmdlet
Get-NetAdapter -Verbose
Get-NetAdapter

##
## dependencies
Get-CimInstance Win32_DependentService | Where-Object Dependent -like '*WinRM*'
$s = Get-CimInstance -ClassName Win32_Service -Filter "Name='WinRM'"
Get-CimAssociatedInstance -InputObject $s -Association Win32_DependentService
Get-CimAssociatedInstance -InputObject $s -ResultClassName Win32_Service
Get-CimAssociatedInstance -InputObject $s -ResultClassName Win32_SystemDriver
## implementing in cdxml
##  just services
Get-Module CIMservice | Remove-Module
Import-Module 'C:\CIMdemo\CIMService\v8\CIMservice.cdxml' -Force
$s = Get-CIMService -Name RpcSs
Get-CIMService -DependsON $s
Get-CIMService -DependsON $s | Select-Object Name, DisplayName
Get-CIMService -DependedON $s
Get-CIMService -DependedON $s | Select-Object Name, DisplayName