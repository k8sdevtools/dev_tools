param (
    [bool]$Override = $false
)

function script {
    param (
        [bool]$Override
    )

    $validationFile = "validation.text"

    if (Test-Path $validationFile -and -not $Override) {
        Write-Output "Validation file exists. Exiting script."
        exit
    }

    Write-Output "Running script..."

    Out-File -FilePath $validationFile -Encoding utf8 -InputObject "script ran"

    Write-Host "Validation file created."
}


# Call the function and pass the Override parameter
powershell.exe -ExecutionPolicy Bypass -File myscript.ps1 -Override $true
