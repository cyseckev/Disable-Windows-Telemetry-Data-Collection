<#
.SYNOPSIS
    Hardens Windows by disabling telemetry, data collection, and unnecessary services.

.DESCRIPTION
    This script applies recommended registry, service, and task modifications
    to reduce Windows telemetry and improve privacy/OPSEC.

    ⚠️ Run as Administrator
#>

Write-Output "[*] Applying Windows telemetry hardening..."

# --- Telemetry minimal / Data Collection ---
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
  -Name "AllowTelemetry" -PropertyType DWord -Value 0 -Force

# --- Tailored experiences (ads/tips) ---
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Force | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" `
  -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value 0 -Force

# --- Advertising ID ---
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" `
  -Name "DisabledByGroupPolicy" -Type DWord -Value 1 -Force

# --- Cortana / Web Search ---
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
  -Name "AllowCortana" -Type DWord -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
  -Name "ConnectedSearchUseWeb" -Type DWord -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
  -Name "DisableWebSearch" -Type DWord -Value 1 -Force

# --- Activity History / Timeline ---
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" `
  -Name "PublishUserActivities" -Type DWord -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" `
  -Name "UploadUserActivities" -Type DWord -Value 0 -Force

# --- Consumer features, tips ---
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" `
  -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" `
  -Name "DisableSoftLanding" -Type DWord -Value 1 -Force

# --- Windows Error Reporting ---
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" `
  -Name "Disabled" -Type DWord -Value 1 -Force

# --- Delivery Optimization ---
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" `
  -Name "DODownloadMode" -Type DWord -Value 0 -Force

# --- Stop telemetry-related services ---
$services = @(
  "DiagTrack", "dmwappushservice",
  "WerSvc", "DoSvc",
  "RemoteRegistry",
  "XblAuthManager","XblGameSave","XboxGipSvc","XboxNetApiSvc"
)
foreach ($svc in $services) {
    Stop-Service $svc -Force -ErrorAction SilentlyContinue
    Set-Service $svc -StartupType Disabled -ErrorAction SilentlyContinue
}

# --- Disable scheduled tasks ---
$tasks = @(
  "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
  "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
  "\Microsoft\Windows\Application Experience\AitAgent",
  "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
  "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
  "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
  "\Microsoft\Windows\Feedback\Siuf\DmClient",
  "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
)
foreach ($task in $tasks) {
    schtasks /Change /TN $task /Disable 2>$null
}

# --- Disable LLMNR ---
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" `
  -Name "EnableMulticast" -Type DWord -Value 0 -Force

# --- Disable NetBIOS ---
wmic nicconfig where TcpipNetbiosOptions!=null call SetTcpipNetbios 2 | Out-Null

# --- Disable SMBv1 ---
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue

# --- Disable NCSI Active Probing ---
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" `
  -Name "EnableActiveProbing" -Type DWord -Value 0 -Force

Write-Output "[+] Telemetry hardening applied successfully."
