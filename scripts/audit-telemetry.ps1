<#
.SYNOPSIS
    Audits Windows telemetry state.

.DESCRIPTION
    Checks relevant registry keys, services, and tasks to verify that telemetry
    has been disabled successfully.
#>

Write-Output "[*] Auditing telemetry settings..."

# --- Registry keys ---
$regChecks = @{
  "AllowTelemetry" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
  "TailoredExperiences" = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
  "AdvertisingID" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
  "Cortana" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
  "ActivityHistory" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
  "ConsumerFeatures" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
  "ErrorReporting" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
  "DeliveryOptimization" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
  "LLMNR" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
  "NCSI" = "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet"
}
foreach ($key in $regChecks.Keys) {
    $path = $regChecks[$key]
    try {
        $val = Get-ItemProperty -Path $path -ErrorAction Stop
        Write-Output "[OK] $key found in $path"
    } catch {
        Write-Output "[!] $key missing or not set in $path"
    }
}

# --- Services ---
$services = @("DiagTrack","dmwappushservice","WerSvc","DoSvc","RemoteRegistry")
foreach ($svc in $services) {
    try {
        $s = Get-Service $svc -ErrorAction Stop
        if ($s.Status -eq "Stopped" -and $s.StartType -eq "Disabled") {
            Write-Output "[OK] Service $svc is disabled"
        } else {
            Write-Output "[!] Service $svc is not disabled"
        }
    } catch {
        Write-Output "[i] Service $svc not found"
    }
}

# --- Scheduled tasks ---
$tasks = @(
  "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
  "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
)
foreach ($task in $tasks) {
    try {
        $t = schtasks /Query /TN $task /FO LIST 2>$null
        if ($t -match "Disabled:  Yes") {
            Write-Output "[OK] Task $task disabled"
        } else {
            Write-Output "[!] Task $task still active"
        }
    } catch {
        Write-Output "[i] Task $task not found"
    }
}

Write-Output "[+] Audit completed."
