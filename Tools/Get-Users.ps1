function Get-Users {
Param(
    [string]$domain = '',
    [string]$DN = '',
    [string]$username = '',
    [string]$password = ''
)
if($domain -eq ''){$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
if($DN -eq ''){$DN = ([adsi]'').distinguishedName}
$ldapmon = "LDAP://$domain/$DN"
}
else{
$ldapmon = "LDAP://$domain"}
try
{
    if($username -eq '' -and $password -eq '')
    {
    $Entrymon = New-Object System.DirectoryServices.DirectoryEntry("$ldapmon")
    }
    else
    {
    $Entrymon = New-Object System.DirectoryServices.DirectoryEntry("$ldapmon",$username,$password)
    }
}
catch
{
    Write-Host "Error: $_"
}
$searcher = New-Object System.DirectoryServices.DirectorySearcher($Entrymon, "(&(objectCategory=User)(objectClass=User)(samAccountType=805306368))")
try{
$Users = $searcher.FindALL()

    foreach ($User in $Users) {
            Write-Host  -BackgroundColor DarkCyan -ForegroundColor White "-------------- $($User.Properties.name) -----------------"
            $User.Properties.PropertyNames | ForEach-Object {
            $propertyName = $_
            $propertyValue = $User.Properties[$propertyName][0]
            
            if ($propertyName -eq "lastLogon")
            {
                if ($propertyValue -ne $null) 
                {
                    # Convert lastLogon value to a readable format
                    $lastLogonTime = [DateTime]::FromFileTime([Int64]::Parse($propertyValue[0]))
                    Write-Host "$propertyName : $lastLogonTime"
                } 
                else 
                {
                    Write-Host "$propertyName : cann't detecte"
                }
            }
            elseif ($propertyName -eq "lastLogonTimestamp")
            {
                if ($propertyValue -ne $null) 
                {
                    # Convert lastLogon value to a readable format
                    $lastLogonTimestampTime = [DateTime]::FromFileTime([Int64]::Parse($propertyValue[0]))
                    Write-Host "$propertyName : $lastLogonTimestampTime"
                } 
                else 
                {
                    Write-Host "$propertyName : cann't detecte"
                }
            }
            elseif ($propertyName -eq "accountExpires")
            {
                if ($propertyValue -eq 9223372036854775807) 
                {
                    Write-Host "$propertyName : Never Expires"
                } 
                else 
                {
                    #Write-Host "$propertyName : cann't detecte"
                    try {
                    $expiredate = [DateTime]::FromFileTime([Int64]::Parse($propertyValue[0]))
                    Write-Host "$propertyName : $expiredate"
                    }catch{
                    Write-Host "$propertyName : cann't detecte"
                    }
                }
            }
            elseif ($propertyName -eq "badPasswordTime")
            {
                if ($propertyValue -ne $null) 
                {
                    # Convert the badPasswordTime timestamp to a readable date
                    $badPasswordDateTime = [DateTime]::FromFileTime($propertyValue[0])
                    Write-Host "$propertyName : $badPasswordDateTime"
                } 
                else 
                {
                    Write-Host "$propertyName : cann't detect"
                }
            }
            elseif ($propertyName -eq "nTSecurityDescriptor")
            {
                $ntSecurityDescriptor = $User.ObjectSecurity
                if ($ntSecurityDescriptor) {
                   Write-output "$propertyName : "$ntSecurityDescriptor | Format-List
                } 
                else
                {
                    Write-Host "$propertyName : cann't detect"
                }
               
            }
            elseif ($propertyName -eq "objectGUID")
            {#Write-Host "$propertyName"
                $objectGUIDString = [System.Guid]::New($propertyValue)
                if ($objectGUIDString -ne $null) 
                {
                    Write-Host "$propertyName : $objectGUIDString"
                } 
                else 
                {
                    Write-Host "$propertyName : cann't detect"
                }
            }
            elseif ($propertyName -eq "objectSid")
            {
                $objectSidBytes = $User.Properties[$propertyName][0]
    
                if ($objectSidBytes -ne $null)
                {
                    $objectSid = New-Object System.Security.Principal.SecurityIdentifier($objectSidBytes, 0)
                    Write-Host "$propertyName : $($objectSid.Value)"
                } 
                else 
                {
                    Write-Host "$propertyName : cann't detect"
                }
            }
            elseif ($propertyName -eq "pwdLastSet")
            {
                if ($propertyValue -ne $null) 
                {
                    # Convert pwdLastSet value to a readable format
                    $pwdLastSetTime = [DateTime]::FromFileTime([Int64]::Parse($propertyValue[0]))
                    Write-Host "$propertyName : $pwdLastSetTime"
                } 
                else 
                {
                    Write-Host "$propertyName : cann't detect"
                }
            }
            elseif ($propertyName -eq "uSNChanged")
            {
                if ($propertyValue -ne $null) 
                {
                    # Convert uSNChanged value to a readable format
                    #$uSNChangedTime = [DateTime]::FromFileTime([Int64]::Parse($uSNChanged[0]))
                    Write-Host "$propertyName : $propertyValue"
                } 
                else 
                {
                    Write-Host "$propertyName : cann't detect"
                }
            }
            elseif ($propertyName -eq "uSNCreated")
            {
                if ($propertyValue -ne $null) 
                {
                    # Convert uSNChanged value to a readable format
                    #$uSNCreatedTime = [DateTime]::FromFileTime([Int64]::Parse($uSNCreated[0]))
                    Write-Host "$propertyName : $propertyValue"
                } 
                else 
                {
                    Write-Host "$propertyName : cann't detect"
                }
            }
            else{
                Write-Host "$propertyName : $propertyValue"
            }
        }
    }
}catch{
Write-Host "Error: $_"
}
}
#Get-Users -domain -username -password 