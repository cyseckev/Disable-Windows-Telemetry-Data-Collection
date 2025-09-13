<#
.SYNOPSIS
    Optional script to remove additional telemetry components.

.DESCRIPTION
    Uninstalls optional Windows features and apps related to telemetry.
    ⚠️ Use only if you want a very strict OPSEC setup.
#>

Write-Output "[*] Removing additional telemetry components..."

# Remove built-in telemetry-related features
$features = @(
  "RetailDemoOfflineContent",
  "WindowsMediaPlayer",
  "XPS-Viewer"
)
foreach ($f in $features) {
    Disable-WindowsOptionalFeature -Online -FeatureName $f -NoRestart -ErrorAction SilentlyContinue
}

# Remove preinstalled apps (if present)
$apps = @(
  "Microsoft.XboxApp",
  "Microsoft.GetHelp",
  "Microsoft.Getstarted",
  "Microsoft.Microsoft3DViewer",
  "Microsoft.MicrosoftOfficeHub",
  "Microsoft.SkypeApp",
  "Microsoft.ZuneMusic",
  "Microsoft.ZuneVideo"
)
foreach ($app in $apps) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
}

Write-Output "[+] Additional telemetry components removed."
