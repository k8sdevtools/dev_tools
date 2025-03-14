try {
    # Define the path to Docker's daemon.json configuration file inside WSL
    $dockerConfigPath = "C:\Users\$env:USER\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu..._8wekyb3d8bbwe\LocalState\rootfs\etc\docker\daemon.json"

    # Check if the daemon.json file exists, and create it if it doesn't
    if (-not (Test-Path -Path $dockerConfigPath)) {
        Write-Output "Creating the daemon.json file..."
        New-Item -Path $dockerConfigPath -ItemType File -Force
    }

    # Define the new configuration content
    $configContent = @"
{
  "registry-mirrors": ["https://your-mirror-url.com"],
  "insecure-registries": ["your-insecure-registry.com"],
  "data-root": "/mnt/wsl/docker-data"
}
"@

    # Write the new configuration to the file
    Write-Output "Updating the daemon.json file with the new configuration..."
    Set-Content -Path $dockerConfigPath -Value $configContent

    # Restart Docker service inside WSL
    Write-Output "Restarting Docker service..."
    wsl sudo service docker restart

    # Verify the configuration changes
    Write-Output "Verifying Docker settings..."
    $dockerInfo = wsl docker info | Select-String "Registry Mirrors|Insecure Registries|Docker Root Dir"
    Write-Output "Docker settings after update:"
    Write-Output $dockerInfo

    Write-Output "Docker configuration updated successfully."

} catch {
    Write-Output "An error occurred: $_"
    exit 1
}
