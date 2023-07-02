Function Set-1PasswordEnv {
    <#
    .SYNOPSIS
    Sets 1Password env vars from a file. Replace this with your own.
    Content of file should be:
    $env:OP_SERVICE_ACCOUNT_TOKEN = <token>
    #>
    . C:\ENV\op.ps1
}

Function Remove-1PasswordEnv {
    Remove-Item -Path 'env:OP_SERVICE_ACCOUNT_TOKEN'
}

$1pItems = @{
    # Aliases for 1Password item IDs for convenience
    'restic' = 'asdfsdfsdfsdfsdfsdfsdfsdfsdf'
}

Function Set-1PasswordItemEnv {
    <#
    .SYNOPSIS
    Sets env vars based on a 1Password item

    .DESCRIPTION
    Requires each item to have a section label of ENV
    and each field to have a label of the env var name
    #>

    [CmdletBinding()]
    Param(
        [string]$VaultName,
        [string]$ItemName
    )
    Process {
        $itemID = $1pItems[$ItemName]
        if ($null -eq $itemID) {
            throw "No item found for $ItemName"
        }

        # First, set the 1Password service account env var
        Set-1PasswordEnv

        # Then, set the env vars from the item
        $fields = (op item get --vault $VaultName $itemID --format json | 
                ConvertFrom-Json).fields 
            | Where-Object {
                $null -ne $_.section.label -and
                $_.section.label -eq 'ENV' 
            }
        foreach ($field in $fields) {
            Set-Item -Path "env:$($field.label)" -Value $field.value
        }
    }
    End {
        Remove-1PasswordEnv
    }
}

Function Remove-1PasswordItemEnv {
    <#
    .SYNOPSIS
    Clears env vars based on a 1Password item

    .DESCRIPTION
    Requires each item to have a section label of ENV
    and each field to have a label of the env var name
    #>

    [CmdletBinding()]
    Param(
        [string]$VaultName,
        [string]$ItemName
    )
    Process {
        $itemID = $1pItems[$ItemName]
        if ($null -eq $itemID) {
            throw "No item found for $ItemName"
        }

        # First, set the 1Password service account env var
        Set-1PasswordEnv

        # Then, set the env vars from the item
        $fields = (op item get --vault $VaultName $itemID --format json | 
                ConvertFrom-Json).fields 
            | Where-Object {
                $null -ne $_.section.label -and
                $_.section.label -eq 'ENV' 
            }
        foreach ($field in $fields) {
            Remove-Item -Path "env:$($field.label)"
        }
    }
    End {
        Remove-1PasswordEnv
    }
}

Export-ModuleMember -Function *-*
