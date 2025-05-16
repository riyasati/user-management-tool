# user-management.ps1

function Show-Menu {
    Clear-Host
    Write-Host "User Management Tool" -ForegroundColor Cyan
    Write-Host "1. List Users"
    Write-Host "2. Create User"
    Write-Host "3. Delete User"
    Write-Host "4. Change User Password"
    Write-Host "5. Disable User"
    Write-Host "6. Enable User"
    Write-Host "7. Show Failed Login Attempts"
    Write-Host "8. List Running Services"
    Write-Host "9. Restart a Service"
    Write-Host "10. Simulate Mail Client Setup"
    Write-Host "11. Simulate LDAP Lookup"
    Write-Host "12. Show Disks (Simulate RAID Awareness)"
    Write-Host "0. Exit"

}

function List-Users {
    Get-LocalUser | Select-Object Name, Enabled
    Pause
}

function Create-User {
    $username = Read-Host "Enter new username"
    $password = Read-Host "Enter password" -AsSecureString
    New-LocalUser -Name $username -Password $password -FullName $username -Description "Created via script"
    Add-LocalGroupMember -Group "Users" -Member $username
    Write-Host "User '$username' created."
    Pause
}

function Delete-User {
    $username = Read-Host "Enter username to delete"
    Remove-LocalUser -Name $username
    Write-Host "User '$username' deleted."
    Pause
}
function Change-UserPassword {
    $username = Read-Host "Enter the username to change password"
    $newPass = Read-Host "Enter new password" -AsSecureString
    Set-LocalUser -Name $username -Password $newPass
    Write-Host "Password changed for $username" -ForegroundColor Green
}

function Disable-User {
    $username = Read-Host "Enter username to disable"
    Disable-LocalUser -Name $username
    Write-Host "$username has been disabled" -ForegroundColor Red
}

function Enable-User {
    $username = Read-Host "Enter username to enable"
    Enable-LocalUser -Name $username
    Write-Host "$username has been enabled" -ForegroundColor Green
}

function Show-FailedLogins {
    Get-EventLog -LogName Security -InstanceId 4625 -Newest 5 | 
        Format-Table TimeGenerated, Message -Wrap
}

function List-RunningServices {
    Get-Service | Where-Object { $_.Status -eq 'Running' } | Format-Table Name, Status
}

function Restart-ServicePrompt {
    $svc = Read-Host "Enter service name to restart"
    Restart-Service -Name $svc -Force
    Write-Host "$svc restarted." -ForegroundColor Green
}

function Simulate-MailSetup {
    Write-Host "Configuring Outlook profile for: user@example.com" -ForegroundColor Yellow
    Write-Host "Server: smtp.example.com | Protocol: IMAP | Port: 993"
    Start-Sleep 2
    Write-Host "Mail client simulated setup complete!" -ForegroundColor Green
}

function Simulate-LDAPLookup {
    Write-Host "Looking up LDAP entry for user01@example.com"
    Write-Host "CN=user01, OU=Engineering, DC=example, DC=com"
}

function Show-Disks {
    Get-Volume | Format-Table DriveLetter, FileSystemLabel, FileSystem, SizeRemaining, Size
}


# Main loop
do {
    Show-Menu
    $choice = Read-Host "Choose an option"
    switch ($choice) {
        "1" { List-Users }
        "2" { Create-User }
        "3" { Delete-User }
        "4" { Change-UserPassword }
    "5" { Disable-User }
    "6" { Enable-User }
    "7" { Show-FailedLogins }
    "8" { List-RunningServices }
    "9" { Restart-ServicePrompt }
    "10" { Simulate-MailSetup }
    "11" { Simulate-LDAPLookup }
    "12" { Show-Disks }
    "0" { exit }
        default { Write-Host "Invalid option"; Pause }
    }
} while ($true)
