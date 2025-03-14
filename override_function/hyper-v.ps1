try {
    # Enable Hyper-V and check if it requires a restart
    $hyperVResult = Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart -ErrorAction Stop

    if ($hyperVResult.RestartNeeded -eq $false) {
        Write-Output "Hyper-V installed successfully."
    } else {
        Write-Output "Hyper-V installed, but a restart is required."
    }

    # Install Docker CE (Docker Engine) manually from the MSI package
    Write-Output "Installing Docker CE..."
    $dockerMSIUrl = "https://download.docker.com/win/stable/Docker%20for%20Windows%20Server%20(Windows%2010%20Pro).msi"
    $dockerMSIPath = "$env:TEMP\DockerEngine.msi"

    Invoke-WebRequest -Uri $dockerMSIUrl -OutFile $dockerMSIPath

    Start-Process msiexec.exe -ArgumentList "/i", "$dockerMSIPath", "/quiet", "/norestart" -Wait

    # Clean up the installer
    Remove-Item -Path $dockerMSIPath -Force

    Write-Output "Docker Engine (Docker CE) installed successfully."

    # Switch Docker to Windows Containers (Hyper-V mode)
    Write-Output "Switching Docker to Windows Containers (Hyper-V)..."
    & "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon

    # Modify Docker configuration to change data-root, registry-mirrors, and insecure-registries
    $dockerConfigPath = "C:\ProgramData\Docker\config\daemon.json"

    # Check if daemon.json exists and create it if not
    if (-not (Test-Path -Path $dockerConfigPath)) {
        Write-Output "Creating Docker configuration file (daemon.json)..."
        New-Item -Path $dockerConfigPath -ItemType File -Force
    }

    # Write the JSON content directly
    $jsonConfig = @"
{
  "registry-mirrors": ["https://your-mirror-url.com"],
  "insecure-registries": ["your-insecure-registry.com"],
  "data-root": "C:\\docker"
}
"@
    
    # Write the JSON to the daemon.json file
    Set-Content -Path $dockerConfigPath -Value $jsonConfig -Force

    Write-Output "Docker configuration updated with new registry mirrors, insecure registries, and data-root."

    # Ensure Docker service is running
    $dockerStatus = Get-Service -Name "com.docker.service" -ErrorAction SilentlyContinue
    if ($dockerStatus.Status -ne 'Running') {
        Write-Output "Starting Docker..."
        Start-Service -Name "com.docker.service"
        Start-Sleep -Seconds 10
    }

    # Build the Docker image
    $dockerImage = "my-docker-image"
    $dockerfilePath = "."

    Write-Output "Building Docker image..."
    docker build -t $dockerImage $dockerfilePath

    if ($?) {
        Write-Output "Docker build completed successfully."
    } else {
        Write-Output "Docker build failed."
    }

} catch {
    Write-Output "An error occurred: $_"
    exit 1
}
