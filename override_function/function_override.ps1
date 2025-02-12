param (
    [bool]$Override = $false
)

$validationFile = "validation.text"

# Check if the validation file exists and apply the override logic
if (Test-Path $validationFile -and -not $Override) {
    Write-Output "Validation file exists. Exiting script."
    exit
}
# Call the function and pass the Override parameter
powershell.exe -ExecutionPolicy Bypass -File myscript.ps1 -Override $true
