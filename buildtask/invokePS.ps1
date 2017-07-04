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

Invoke-Command -ComputerName $machinesList -credential $credential  -ScriptBlock {

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
}
} -ArgumentList ($ApppoolName, $stopstart)