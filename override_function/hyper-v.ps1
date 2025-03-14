try {
    # Enable WSL and Virtual Machine Platform features
    Write-Output "Enabling WSL 2 and Virtual Machine Platform..."
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -ErrorAction Stop
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -ErrorAction Stop
    Write-Output "WSL 2 and Virtual Machine Platform enabled successfully."

    # Set WSL 2 as the default version
    Write-Output "Setting WSL 2 as the default version..."
    wsl --set-default-version 2

    # Install Ubuntu as the default WSL 2 distro (if not already installed)
    Write-Output "Installing Ubuntu on WSL..."
    wsl --install -d Ubuntu

    # Update package list and install Docker CE inside WSL 2
    Write-Output "Updating package list and installing Docker CE in WSL 2..."
    wsl -d Ubuntu -- sudo apt update
    wsl -d Ubuntu -- sudo apt install -y docker.io
    wsl -d Ubuntu -- sudo usermod -aG docker $USER

    # Start Docker inside WSL 2
    Write-Output "Starting Docker in WSL 2..."
    wsl -d Ubuntu -- sudo service docker start

    # Verify Docker is running inside WSL 2
    Write-Output "Verifying Docker installation..."
    $dockerInfo = wsl -d Ubuntu -- docker info | Select-String "Operating System"
    Write-Output "Docker is running inside: $dockerInfo"

    Write-Output "Docker CE setup in WSL 2 completed successfully."

} catch {
    Write-Output "An error occurred during setup. Error: $_"
    exit 1
}
