try {
    # Enable Hyper-V
    $result = Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart -ErrorAction Stop
    if ($result.RestartNeeded -eq $false) {
        Write-Output "Hyper-V installed successfully."

        # Switch Docker to use Hyper-V
        Write-Output "Switching Docker to Hyper-V..."
        & "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon

        # Verify Docker is using Hyper-V
        Write-Output "Verifying Docker backend..."
        docker info | Select-String "Operating System"

    } else {
        Write-Output "Hyper-V installed, but a restart is required. Restarting system..."
        Restart-Computer -Force
    }

} catch {
    Write-Output "Hyper-V not installed. Error: $_"
    exit 1
}