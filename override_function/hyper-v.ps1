for ($i = 1; $i -le 1; $i++) {
    try {
        $result = Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart -ErrorAction Stop
        if ($result.RestartNeeded -eq $false) {
            Write-Output "Hyper-V installed successfully."
        } else {
            Write-Output "Hyper-V installed, but a restart is required."
        }
    } catch {
        Write-Output "Hyper-V not installed. Error: $_"
    }
}