param (
        [string]$machinesList,
        [string]$AdminUserName,
        [string]$AdminPassword,
        [string]$ApppoolName,
        [string]$stopstart      
        )

Write-Output "Machine Name - $machinesList"
Write-Output "Admin User Name - $AdminUserName"
Write-Output "Application Pool Name - $ApppoolName"
Write-Output "Action selected - $stopstart"

$pass = ConvertTo-SecureString -AsPlainText $AdminPassword -Force

$credential = new-object -typename System.Management.Automation.PSCredential -argumentlist $AdminUserName,$pass
$session = New-PSSession -ComputerName $machinesList -Credential $credential -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck)

Invoke-Command -Session $session -credential $credential  -ScriptBlock {

param (
        [string]$AppPoolName,
        [string]$Action)
        
if ($Action -eq "stop")
{
    Write-Output "Stoping the Application Pool - ($AppPoolName)......."
    import-module WebAdministration
    if((Get-WebAppPoolState $AppPoolName).Value -ne 'Stopped')
    {
        Stop-WebAppPool -Name $AppPoolName
        Write-Output "Application Pool - ($AppPoolName) stopped successfully!" 
    }
     else
    {
        Write-Output "Application Pool - ($AppPoolName) already in stop state!"
    }
}

if ($Action -eq "start")
{
    Write-Output "Starting the Application Pool - ($AppPoolName)......."
    import-module WebAdministration
    if((Get-WebAppPoolState $AppPoolName).Value -ne 'Started')
    {
        Start-WebAppPool -Name $AppPoolName
        Write-Output "Application Pool - ($AppPoolName) started successfully!"
    }
    else
    {
        Write-Output "Application Pool - ($AppPoolName) already in start state!"
    }
}

if ($Action -eq "restart")
{
    Write-Output "Restarting the Application Pool - ($AppPoolName)......."
    import-module WebAdministration
    if((Get-WebAppPoolState $AppPoolName).Value -ne 'Stopped')
    {
        Restart-WebAppPool -Name $AppPoolName
        Write-Output "Application Pool - ($AppPoolName) restarted successfully!"
    }
    else
    {
        Write-Output "Application Pool - ($AppPoolName) can not be restarted as it is in stop state. Please start it first!"
    }
}
} -ArgumentList ($ApppoolName, $stopstart)